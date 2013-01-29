//(function ($) {

    function get_pages_from_articles(articles) {
      console.log(articles.length);
      var pages = [];
      for (var i = 0; i < 1; i++) {
        var page = []; var aas = [];
        for (var j = 0; j < 5; j++) {
          aas[j] = articles[i*5+j];
        }
        page.articles = aas;
        console.log(page.articles.length);
        pages[i] = page;
      }
      return pages;
    }
    
  $.getJSON('/articles.json', function(data) {
  
    var pages = get_pages_from_articles(data);
    
    var Page = Backbone.Model.extend({ defaults:{ articles: [] }  });
    
    var Pages = Backbone.Collection.extend({  model:Page  });

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
    
    var PagesView = Backbone.View.extend({
        el:$("#pages"),

        initialize:function(){
            this.collection = new Pages(pages);
            this.render();
            $('#pages').replaceWith(this.el.children);
        },

        render: function(){
            var that = this;
            _.each(this.collection.models, function(item){
                that.renderPage(item);
            }, this);

        },

        renderPage:function(item){
            var pageView = new PageView({ model: item });
            this.$el.append(pageView.render().el);
        }
    });

    var pagesView = new PagesView();
    
    // start flip processing
    
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