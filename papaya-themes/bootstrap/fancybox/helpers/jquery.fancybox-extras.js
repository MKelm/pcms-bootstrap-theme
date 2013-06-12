 /*!
 * Extras helper for fancyBox
 * version: 1.0.3 (Wed, 12 Jun 2013)
 * @copyright Martin Kelm, 2013, http://mkelm.github.io
 * @requires fancyBox v2.0 or later
 *
 * Usage:
 *     $(".fancybox").fancybox({
 *         helpers : {
 *             extras: {
 *                 url : 'http://loadextras.php'
 *                 title : 'Extras'
 *             }
 *         }
 *     });
 *
 */
(function ($) {
  //Shortcut for fancyBox object
  var F = $.fancybox,
    getScalar = function(orig, dim) {
      var value = parseInt(orig, 10) || 0;

      if (dim && isPercentage(orig)) {
        value = F.getViewport()[ dim ] / 100 * value;
      }

      return Math.ceil(value);
    };

  //Add helper object
  F.helpers.extras = {
    defaults : {
      type            : 'float', // 'float', 'inside', 'outside' or 'over',
      position        : 'bottom', // 'top' or 'bottom'
      linkTitle       : 'Show extras ', // title of extras link
      linkTitleActive : 'Show image', // title of extras link
      urls            : [], // urls to load extras from
      content         : '', // current extras content
      executeOnLoad   : [] // functions to execute on load with parameters
    },

    beforeShow: function (opts) {
      var current = F.current,
        type = opts.type,
        urls = opts.urls;
      if (urls[current.index] !== undefined && urls[current.index].length > 0) {
        openLink = $('<div class="fancybox-extras-link fancybox-extras-link-' + type +
          '-wrap fancybox-extras-link-' + opts.position + '"><a href="#">'
          + opts.linkTitle + '</a></div>');

        switch (type) {
          case 'inside':
            target = F.skin;
          break;

          case 'outside':
            target = F.wrap;
          break;

          case 'over':
            target = F.inner;
          break;

          default: // 'float'
            target = F.skin;

            openLink.appendTo('body');

            if (F.IE) {
              description.width( openLink.width() );
            }

            openLink.wrapInner('<span class="child"></span>');

            //Increase bottom margin so this title will also fit into viewport
            F.current.margin[2] += Math.abs( getScalar(openLink.css('margin-bottom')) );
          break;
        }

        openLink[ (opts.position === 'top' ? 'prependTo'  : 'appendTo') ](target);
      }
    },

    showExtrasContent: function (opts) {
      // hide fancybox content with image and navigation links
      $('.fancybox-skin').children(':not(.fancybox-extras-link, .fancybox-item)').hide();
      // add extras content area to fancybox
      $('.fancybox-skin').prepend(
        '<div class="fancybox-extras-content">' + opts.content + '</div>'
      );
      // add click events on internal links
      var currentUrl = opts.urls[F.current.index];
      $('.fancybox-skin .fancybox-extras-content').find('a[href ^= "' + currentUrl + '"]').click(function () {
        $.get($(this).attr('href'), function(data) {
          opts.content = $(data).children('requested-content').html();
          F.helpers.extras.showExtrasContent(opts);
        });
        return false;
      });
      // add target blank on external links
      $('.fancybox-skin .fancybox-extras-content').find('a[href *= "http"]').attr('target', '_blank');
      // add form submit click event for first form in content
      $('.fancybox-skin .fancybox-extras-content').find('button[type = "submit"]').click(function () {
        var form = $(this).parents('form:first');
        $.post($(form).attr('action'), $(form).serialize(), function(data) {
          opts.content = $(data).children('requested-content').html();
          F.helpers.extras.showExtrasContent(opts);
        });
        return false;
      });
      // reset content link click event to hide extras content
      $('.fancybox-extras-link a').unbind('click').click(function () {
        F.helpers.extras.hideExtrasContent(opts);
      });
      $('.fancybox-extras-link a').html(opts.linkTitleActive);
      // execute additional onLoad functions
      if (opts.executeOnLoad.length > 0) {
        for (var i = 0; i < opts.executeOnLoad.length; i++) {
          eval(opts.executeOnLoad[i]+';');
        }
      }
    },

    hideExtrasContent: function (opts) {
      $('.fancybox-skin .fancybox-extras-content').hide();
      $('.fancybox-skin').children(':not(.fancybox-extras-content)').show();
      $('.fancybox-extras-link a').unbind('click').click(function () {
        F.helpers.extras.showExtrasContent(opts);
      });
      $('.fancybox-extras-link a').html(opts.linkTitle);
    },

    beforeShowExtrasContent: function (opts) {
      $.ajax({
        url : opts.urls[F.current.index],
      }).done(function (data) {
        opts.content = $(data).children('requested-content').html();
        F.helpers.extras.showExtrasContent(opts);
      });
    },

    afterShow: function (opts) {
      $('.fancybox-extras-link a').click(function () {
        F.helpers.extras.beforeShowExtrasContent(opts);
      });
    }
  };

}(jQuery));