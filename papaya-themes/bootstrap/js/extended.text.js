// extended text features, (c) Martin Kelm, 2013
var extendedText = {
  defaults : {
    elementType : '', // set it in a seperate js file: comment or message
    elementSelector : '', // set it in a seperate js file and perform onLoad after that
    detectFirstUrlOnly : false,
    detectFirstImgUrlOnly : false,
    detectFirstVideoUrlOnly : true,
    imgHandlerUrl : '', // load in onLoad by form hidden field
    imgPreloaderImage : '', // load in onLoad by element after form
    videoHandlerUrl : '', // load in onLoad by form hidden field
    ctrlDown : false,
    ctrlKey  : 17,
    vKey     : 86,
    cKey     : 67,
    spaceKey : 32,
    pasteEvent : false,
    pastePosStart : 0,
    pastePosEnd : 0,
    urlPattern : /(\b(((?:ht|f)tps?:\/\/)|www\.)[a-z0-9-._~!$\'()*+,;=:\/?#[\]@%]+(?:(?!&(?:gt|\#0*62|\#x0*3e);|&(?:amp|apos|quot|\#0*3[49]|\#x0*2[27]);[.!&\',:?;]?(?:[^a-z0-9\-._~!$&\'()*+,;=:\/?#[\]@%]|$))&[a-z0-9\-._~!$\'()*+,;=:\/?#[\]@%]*)*[a-z0-9\-_~$()*+=\/#[\]@%])/img,
    imgPattern : /(\.(jpg|jpeg|gif|png))/img,
    videoPattern : /youtube\.com\/watch\?(.*)?v=([a-zA-Z0-9]+)|vimeo\.com\/([0-9]+)/img
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
    // get image handler url by hidden field
    self.defaults.imgHandlerUrl = $(self.defaults.elementSelector)
      .parents('form:first').children('input[name *= "image_handler_url"]:first').val();
    // get image preloader image from thumbnails container
    self.defaults.imgPreloaderImage = $(self.defaults.elementSelector).parents('form:first')
      .next().attr('data-preloader-image');
    // get video handler url by hidden field
    self.defaults.videoHandlerUrl = $(self.defaults.elementSelector)
      .parents('form:first').children('input[name *= "video_handler_url"]:first').val();
    // further events with at least one handler url only
    if (self.defaults.videoHandlerUrl != undefined || self.defaults.imgHandlerUrl != undefined) {
      // set onclick event for submit button to disable unload session values event on submit
      $(self.defaults.elementSelector).parents('form:first').children('button[type = "submit"]:first')
        .click(function () {
          self.urlsSubmitted = true;
          return true;
        });
      // url detection on space bar events
      $(self.defaults.elementSelector).keyup(function(e) {
        if (e.keyCode == self.defaults.spaceKey) {
          var text = $(this).val(), endPos = text.length - 1, startPos = 0;
          for (var i = endPos; i > 0; i--) {
            var char = text.substring(i - 1, i);
            if (char == ' ') {
              startPos = i;
              i = 0;
            }
          }
          if (endPos > startPos) self.detectUrlFromText(self, text.substring(startPos, endPos));
        }
      });
      // url detection on paste events with text selection support (needs  the jQuery selection plug-in)
      $(self.defaults.elementSelector).keydown(function(e) {
        if (e.keyCode == self.defaults.ctrlKey) self.defaults.ctrlDown = true;
      }).keyup(function(e) {
        if (e.keyCode == self.defaults.ctrlKey) self.defaults.ctrlDown = false;
      });
      $(self.defaults.elementSelector).keydown(function(e) {
        if (self.defaults.ctrlDown == true && e.keyCode == self.defaults.vKey) {
          self.defaults.pasteEvent = true;
          var text = $(this).val(), selectionPos = $(this).selection('getPos');
          if (selectionPos.end > selectionPos.start) {
            self.defaults.pastePosStart = selectionPos.start;
          } else if (text == '') {
            self.defaults.pastePosStart = 0;
          } else {
            self.defaults.pastePosStart = text.length;
          }
        }
      }).keyup(function() {
        if (self.defaults.pasteEvent == true) {
          var text = $(this).val();
          self.defaults.pastePosEnd = text.length;
          self.detectUrlFromText(
            self, text.substring(self.defaults.pastePosStart, self.defaults.pastePosEnd)
          );
          self.defaults.pasteEvent = false;
        };
      });
      // url handler requests on unload to unset session values of the current session idents
      $(window).on('beforeunload', function () {
        // the urlsSubmitted flag can be changed by the submit button click event
        if (self.urlsSubmitted == false) {
          if (self.urlCacheImgs.length > 0) {
            $.ajax({ url : self.defaults.imgHandlerUrl, async : false });
          }
          if (self.urlCacheVideos.length > 0) {
            $.ajax({ url : self.defaults.videoHandlerUrl, async : false });
          }
        }
      });
    }
  },

  detectUrlFromText : function(self, text) {
    text = $.trim(text);
    if (text.substring(0, 4) == 'www.') text = 'http://' + text;
    if ($.inArray(text, self.urlCache) == -1 && $.inArray(text, self.urlCacheImgs) == -1 &&
        $.inArray(text, self.urlCacheVideos) == -1) {
      if (text.match(self.defaults.urlPattern)) {
        if (self.defaults.imgHandlerUrl != undefined && text.match(self.defaults.imgPattern)) {
          if (self.urlCacheImgs.length > 0 && self.defaults.detectFirstImgUrlOnly == true) return false;
          self.urlCacheImgs.push(text);
          var requestUrl = self.defaults.imgHandlerUrl.replace(
            encodeURIComponent('{URL}'), encodeURIComponent(text)
          );
          $(self.defaults.elementSelector).parents('form:first').next().append(
            '<img class="thumbnail pull-left" alt="" src="' + self.defaults.imgPreloaderImage + '" />'
          );
          $.ajax({ url : requestUrl }).done(function (data) {
            // the next element after the form must be preparated as container for image thumbnails
            $(self.defaults.elementSelector).parents('div:first')
              .children('form ~ p.' + self.defaults.elementType + '-form-thumbnails')
              .children('.thumbnail:last').replaceWith(
                $(data).children('requested-content').html()
              );
          });
        } else if (self.defaults.videoHandlerUrl != undefined && text.match(self.defaults.videoPattern)) {
          if (self.urlCacheVideos.length > 0 && self.defaults.detectFirstVideoUrlOnly == true) return false;
          self.urlCacheVideos.push(text);
          var requestUrl = self.defaults.videoHandlerUrl.replace(
            encodeURIComponent('{URL}'), encodeURIComponent(text)
          );
          $.ajax({ url : requestUrl }).done(function (data) {
            // the second element after the form must be preparated as container for image thumbnails
            $(self.defaults.elementSelector).parents('div:first')
              .children('form ~ p.' + self.defaults.elementType + '-form-videos')
              .append(
                $(data).children('requested-content').html()
              );
          });
        } else {
          // this part is for further extensions, no url functionalities at the moment
          // if (self.urlCache.length > 0 && self.defaults.detectFirstUrlOnly == true) return false;
          // self.urlCache.push(text);
        }
      }
    }
  },

  removeEventListeners : function(self) {
    $(self.defaults.elementSelector).unbind('keydown');
    $(self.defaults.elementSelector).unbind('keyup');
  }
};