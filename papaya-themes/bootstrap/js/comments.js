$( document ).ready(function() {

  var extendedText = {
    defaults : {
      elementSelector : '#dialogCommentText',
      detectFirstUrlOnly : false,
      imgHandlerUrl : '',
      ctrlDown : false,
      ctrlKey  : 17,
      vKey     : 86,
      cKey     : 67,
      spaceKey : 32,
      pasteEvent : false,
      pastePosStart : 0,
      pastePosEnd : 0,
      urlPattern : /(\b(((?:ht|f)tps?:\/\/)|www\.)[a-z0-9-._~!$\'()*+,;=:\/?#[\]@%]+(?:(?!&(?:gt|\#0*62|\#x0*3e);|&(?:amp|apos|quot|\#0*3[49]|\#x0*2[27]);[.!&\',:?;]?(?:[^a-z0-9\-._~!$&\'()*+,;=:\/?#[\]@%]|$))&[a-z0-9\-._~!$\'()*+,;=:\/?#[\]@%]*)*[a-z0-9\-_~$()*+=\/#[\]@%])/img,
      imgPattern : /(\.(jpg|jpeg|gif|png))/img

    },
    /* urlPattern:
     *  (c) 2010 Jeff Roberson - http://jmrware.com, MIT License, github.com\/jmrware\/LinkifyURL
     *  (c) 2013 Martin Kelm, reduced and modified url pattern
     */
    urlCache : [],

    onLoad : function(self, opts) {
      // get image handler url by hidden field
      $(extendedText.defaults.elementSelector).parents('form:first')
        .children('input[type = "hidden"]').each(function() {
          if ($(this).attr('name').match(/image_handler_url/)) {
            extendedText.defaults.imgHandlerUrl = $(this).val();
          }
        });
      // url detection on space bar events
      $(opts.elementSelector).keyup(function(e) {
        if (e.keyCode == opts.spaceKey) {
          var text = $(this).val(), endPos = text.length - 1, startPos = 0;
          for (var i = endPos; i > 0; i--) {
            var char = text.substring(i - 1, i);
            if (char == ' ') {
              startPos = i;
              i = 0;
            }
          }
          if (endPos > startPos) {
            self.detectUrlFromText(self, text.substring(startPos, endPos));
          }
        }
      });
      // url detection on paste events with text selection support (needs  the jQuery selection plug-in)
      $(opts.elementSelector).keydown(function(e) {
        if (e.keyCode == opts.ctrlKey) opts.ctrlDown = true;
      }).keyup(function(e) {
        if (e.keyCode == opts.ctrlKey) opts.ctrlDown = false;
      });
      $(opts.elementSelector).keydown(function(e) {
        if (opts.ctrlDown == true && e.keyCode == opts.vKey) {
          opts.pasteEvent = true;
          var text = $(this).val(), selectionPos = $(this).selection('getPos');
          if (selectionPos.end > selectionPos.start) {
            opts.pastePosStart = selectionPos.start;
          } else if (text == '') {
            opts.pastePosStart = 0;
          } else {
            opts.pastePosStart = text.length;
          }
        }
      }).keyup(function() {
        if (opts.pasteEvent == true) {
          var text = $(this).val();
          opts.pastePosEnd = text.length;
          self.detectUrlFromText(self, text.substring(opts.pastePosStart, opts.pastePosEnd));
          opts.pasteEvent = false;
        };
      });
    },

    detectUrlFromText : function(self, text) {
      text = $.trim(text);
      if (text.substring(0, 4) == 'www.') {
        text = 'http://' + text;
      }
      if ($.inArray(text, self.urlCache) == -1) {
        if (text.match(self.defaults.urlPattern)) {
          self.urlCache.push(text);
          console.log('detected an url ' + text);
          if (self.defaults.detectFirstUrlOnly == true) {
            self.removeEventListeners(self);
          }
          if (text.match(self.defaults.imgPattern)) {
            var requestUrl = self.defaults.imgHandlerUrl.replace(
              encodeURIComponent('{URL}'), encodeURIComponent(text)
            );
            $(self.defaults.elementSelector).parents('form:first').next().append(
              '<div class="thumbnail-container">'+
              '<img class="thumbnail pull-left" alt="" src="papaya-themes/bootstrap/img/thumbnail_link_preloader.gif" />'+
              '</div>'
            );
            $.ajax({
              url : requestUrl
            }).done(function (data) {
              // the next element after the form must be preparated as container for image thumbnails
              $(self.defaults.elementSelector).parents('form:first').next().children('.thumbnail-container:last').html(
                $(data).children('requested-content').html()
              );
            });
          }
        }
      }
    },

    removeEventListeners : function(self) {
      $(self.defaults.elementSelector).unbind('keydown');
      $(self.defaults.elementSelector).unbind('keyup');
    }
  };

  extendedText.onLoad(extendedText, extendedText.defaults);
});