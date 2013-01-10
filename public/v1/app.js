//(function ($) {

    var Page = Backbone.Model.extend({
        defaults:{
            articles: [],
        }
    });

    var PageView = Backbone.View.extend({
        tagName:"div",
        className:"f-page",
        template:$("#pageTemplate").html(),

        render:function () {
            var tmpl = _.template(this.template); //tmpl is a function that takes a JSON object and returns html

            this.$el.html(tmpl(this.model.toJSON())); //this.el is what we defined in tagName. use $el to get access to jQuery html() function
            return this;
        }
    });
    
    $.getJSON('/articles.json?m=中国企业家', function(data) {
    var page = new Page({
      articles: data
    });

    var pageView = new PageView({
        model: page
    });

    function show_page() {
      $("#exp").html(pageView.render().el.children);
      $('#cell1').attr('class', 'box w-25 h-70');
      $('#cell2').attr('class', 'box w-50 h-70 box-b-l box-b-r');
      $('#cell3').attr('class', 'box w-25 h-70');
      $('#cell4').attr('class', 'box w-50 h-30 box-b-r title-top');
      $('#cell5').attr('class', 'box w-50 h-30 title-top');
    }

    show_page();
    
			var $container 	= $( '#flip' ),
				$pages		= $container.children().hide();
			
			Modernizr.load({
				test: Modernizr.csstransforms3d && Modernizr.csstransitions,
				yep : ['js/jquery.tmpl.min.js','js/jquery.history.js',
				       'js/core.string.js','js/jquery.touchSwipe-1.2.5.js',
				       'js/jquery.flips.js'],
				nope: 'css/fallback.css',
				callback : function( url, result, key ) {
					
					if( url === 'css/fallback.css' ) {
						$pages.show();
					}
					else if( url === 'js/jquery.flips.js' ) {
						$container.flips();
					}
			
				}
			});
      });
    

//})(jQuery);