// extended text features, (c) Martin Kelm, 2013
var extendedText = {
  defaults : {
    key : {
      ctrl  : 17,
      v     : 86,
      space : 32,
      enter : 13
    },
    pattern : {
      url   : /(\b(((?:ht|f)tps?:\/\/)|www\.)[a-z0-9-._~!$\'()*+,;=:\/?#[\]@%]+(?:(?!&(?:gt|\#0*62|\#x0*3e);|&(?:amp|apos|quot|\#0*3[49]|\#x0*2[27]);[.!&\',:?;]?(?:[^a-z0-9\-._~!$&\'()*+,;=:\/?#[\]@%]|$))&[a-z0-9\-._~!$\'()*+,;=:\/?#[\]@%]*)*[a-z0-9\-_~$()*+=\/#[\]@%])/img,
      image : /(\.(jpg|jpeg|gif|png))/img,
      video : /youtube\.com\/watch\?(.*)?v=([a-zA-Z0-9\-_]+)|vimeo\.com\/([0-9]+)/img
    }
  },
  options : {
    elementType     : '', // set it in a seperate js file: comment or message
    elementSelector : '', // set it in a seperate js file and perform onLoad after that
    firstUrl : {
      url   : false,
      image : false,
      video : true
    },
    urlHandler : {
      image : '', // load in onLoad by form hidden field
      video : '' // load in onLoad by form hidden field
    },
    preloaderImage : {
      image : '', // load in onLoad by element after form
      video : '' // load in onLoad by element after form
    }
  },
  temp : {
    ctrlDown      : false,
    pasteEvent    : false,
    pastePosStart : 0
  },
  /* urlPattern:
   *  (c) 2010 Jeff Roberson - http://jmrware.com, MIT License, github.com\/jmrware\/LinkifyURL
   *  (c) 2013 Martin Kelm, the reduced and slightly modified url pattern
   */
  urlCache : [],
  urlCacheImgs : [],
  urlCacheVideos : [],
  urlsSubmitted : false,

  onLoad : function(self) {
    var opts = self.options, defs = self.defaults;
    // get image handler url by hidden field
    opts.urlHandler.image = $(opts.elementSelector).parents('form:first')
      .children('input[name *= "image_handler_url"]:first').val();
    // get video handler url by hidden field
    opts.urlHandler.video = $(opts.elementSelector).parents('form:first')
      .children('input[name *= "video_handler_url"]:first').val();
    // further actions with at least one handler url only
    if (opts.urlHandler.video != undefined || opts.urlHandler.image != undefined) {
      // get image preloader image from thumbnails container
      opts.preloaderImage.image = $(opts.elementSelector).parents('div:first')
        .children('form ~ p.' + opts.elementType + '-form-thumbnails').attr('data-preloader-image');
      // get video preloader image from thumbnails container
      opts.preloaderImage.video = $(opts.elementSelector).parents('div:first')
        .children('form ~ p.' + opts.elementType + '-form-videos').attr('data-preloader-image');
      // set onclick event for submit button to disable unload session values event on submit
      $(opts.elementSelector).parents('form:first').children('button[type = "submit"]:first')
        .click(function () {
          self.urlsSubmitted = true;
          return true;
        });
      // url detection on space bar / enter key up events
      $(opts.elementSelector).keyup(function(e) {
        if (e.keyCode == defs.key.space || e.keyCode == defs.key.enter) {
          var textParts = $(this).val().replace('\r\n', '\n').split('\n');
          if (e.keyCode == defs.key.enter) textParts.splice(textParts.length - 1, 1);
          var textSelection = textParts.pop();
          if (e.keyCode == defs.key.enter) {
            var endPos = textSelection.length, startPos = 0;
          } else {
            var endPos = textSelection.length - 1, startPos = 0;
          }
          for (var i = endPos; i > 0; i--) {
            var char = textSelection.substring(i - 1, i);
            if (char == ' ') {
              startPos = i;
              i = 0;
            }
          }
          if (endPos > startPos) self.detectUrlFromText(self, textSelection.substring(startPos, endPos));
        }
      });
      // url detection on paste events with text selection support (needs  the jQuery selection plug-in)
      $(opts.elementSelector).keydown(function(e) {
        if (e.keyCode == defs.key.ctrl) self.temp.ctrlDown = true;
      }).keyup(function(e) {
        if (e.keyCode == defs.key.ctrl) self.temp.ctrlDown = false;
      });
      $(opts.elementSelector).keydown(function(e) {
        if (self.temp.ctrlDown == true && e.keyCode == defs.key.v) {
          self.temp.pasteEvent = true;
          var text = $(this).val(), selectionPos = $(this).selection('getPos');
          if (selectionPos.end > selectionPos.start) {
            self.temp.pastePosStart = selectionPos.start;
          } else if (text == '') {
            self.temp.pastePosStart = 0;
          } else {
            self.temp.pastePosStart = text.length;
          }
        }
      }).keyup(function() {
        if (self.temp.pasteEvent == true) {
          var text = $(this).val();
          self.detectUrlFromText(
            self, text.substring(self.temp.pastePosStart, text.length)
          );
          self.temp.pasteEvent = false;
        };
      });
      // url handler requests on unload to unset session values of the current session idents
      $(window).on('beforeunload', function () {
        // the urlsSubmitted flag can be changed by the submit button click event
        if (self.urlsSubmitted == false) {
          if (self.urlCacheImgs.length > 0) {
            $.ajax({ url : self.opts.urlHandler.image, async : false });
          }
          if (self.urlCacheVideos.length > 0) {
            $.ajax({ url : self.opts.urlHandler.video, async : false });
          }
        }
      });
    }
  },

  replaceVideoPreviewImage : function(element) {
    // get iframe from noscript node and set autoplay parameter into iframe src attribute
    $(element).parents('div.video-preview-image:first').html(
      $(element).parents('div.video-preview-image:first').next().html()
        .replace('" frameborder', '&amp;autoplay=1" frameborder')
    );
    return false;
  },

  detectUrlFromText : function(self, text) {
    var match = text.match(self.defaults.pattern.url);
    if (match) {
      // perform further url detection on match(es)
      for (var i = 0; i < match.length; i++) {
        if (match[i].substring(0, 4) == 'www.') match[i] = 'http://' + match[i];
        self.performFurtherUrlDetection(self, match[i]);
      }
    }
  },

  performFurtherUrlDetection : function(self, url) {
    var defs = self.defaults, opts = self.options;
    if ($.inArray(url, self.urlCache) == -1 && $.inArray(url, self.urlCacheImgs) == -1 &&
        $.inArray(url, self.urlCacheVideos) == -1) {
      if (opts.urlHandler.image != undefined && url.match(defs.pattern.image)) {
        if (self.urlCacheImgs.length > 0 && opts.firstUrl.image == true) return false;
        self.urlCacheImgs.push(url);
        var requestUrl = opts.urlHandler.image.replace(
          encodeURIComponent('{URL}'), encodeURIComponent(url)
        );
        $(opts.elementSelector).parents('div:first')
          .children('form ~ p.' + opts.elementType + '-form-thumbnails')
          .append(
            '<img class="thumbnail pull-left" alt="" src="' + opts.preloaderImage.image + '" />'
          );
        $.ajax({ url : requestUrl }).done(function (data) {
          // the next element after the form must be preparated as container for image thumbnails
          $(opts.elementSelector).parents('div:first')
            .children('form ~ p.' + opts.elementType + '-form-thumbnails')
            .children('.thumbnail:last').replaceWith(
              $(data).children('requested-content').html()
            );
        });
      } else if (opts.urlHandler.video != undefined && url.match(defs.pattern.video)) {
        if (self.urlCacheVideos.length > 0 && opts.firstUrl.video == true) return false;
        self.urlCacheVideos.push(url);
        var requestUrl = opts.urlHandler.video.replace(
          encodeURIComponent('{URL}'), encodeURIComponent(url)
        );
        $(opts.elementSelector).parents('div:first')
          .children('form ~ p.' + opts.elementType + '-form-videos')
          .append(
            '<div class="video-preview thumbnail">' +
            '<img alt="" src="' + opts.preloaderImage.video + '" />' +
            '</div>'
          );
        $.ajax({ url : requestUrl }).done(function (data) {
          // the second element after the form must be preparated as container for image thumbnails
          $(opts.elementSelector).parents('div:first')
            .children('form ~ p.' + opts.elementType + '-form-videos')
            .children('.thumbnail:last').replaceWith(
              $(data).children('requested-content').html()
            );
        });
      } else {
        // this part is for further extensions, no url functionalities at the moment
        // if (self.urlCache.length > 0 && opts.firstUrl.url == true) return false;
        // self.urlCache.push(url);
      }
    }
  },

  removeEventListeners : function(self) {
    $(self.options.elementSelector).unbind('keydown');
    $(self.options.elementSelector).unbind('keyup');
  }
};