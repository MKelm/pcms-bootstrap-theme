 /*!
 * Extras helper for fancyBox
 * version: 1.0.0 (Mon, 3 Jun 2013)
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
	var F = $.fancybox;

	//Add helper object
	F.helpers.extras = {
		defaults : {
			type     : 'float', // 'float', 'inside', 'outside' or 'over',
			position : 'bottom', // 'top' or 'bottom'
      title    : 'Extra Content', // title of extra content link
      urls     : [], // urls to load extras from
      content  : '' // current extras content
		},

		beforeShow: function (opts) {
			var current = F.current,
        type = opts.type,
        urls = opts.urls;
      if (urls[current.index] !== undefined && urls[current.index].length > 0) {
        openLink = $('<div class="fancybox-extra-content fancybox-extracontent-' + type +
          '-wrap"><a href="#" id="fancyBoxExtraContentLink">' + opts.title + '</a></div>');

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

            if (IE) {
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

    showExtraContent: function (opts) {
      $('.fancybox-skin').children(':not(.fancybox-extra-content, .fancybox-item)').hide();

      $('.fancybox-skin').prepend(
        '<div class="fancybox-extra-content-area">' + opts.content + '</div>'
      );

      $('a#fancyBoxExtraContentLink').unbind('click');
      $('a#fancyBoxExtraContentLink').click(function () {
        F.helpers.extras.hideExtraContent(opts);
      });
    },

    hideExtraContent: function (opts) {
      $('.fancybox-skin .fancybox-extra-content-area').hide();
      $('.fancybox-skin').children(':not(.fancybox-extra-content-area)').show();
      $('a#fancyBoxExtraContentLink').unbind('click');
      $('a#fancyBoxExtraContentLink').click(function () {
        F.helpers.extras.showExtraContent(opts);
      });
    },

    beforeShowExtraContent: function (opts) {
      $.ajax({
        url : opts.urls[F.current.index],
      }).done(function ( data ) {
        opts.content= $(data).children('requested-content').html();
        F.helpers.extras.showExtraContent(opts);
      });
    },

    afterShow: function (opts) {
      $('a#fancyBoxExtraContentLink').click(function () {
        F.helpers.extras.beforeShowExtraContent(opts);
      });
    }
	};

}(jQuery));