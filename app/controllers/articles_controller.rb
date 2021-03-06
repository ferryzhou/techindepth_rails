class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.json
  def index
    if params[:m]
      @articles = Magzine.where(:name => params[:m]).first.articles.paginate(:page => params[:page], :per_page => 15).order("pubdate DESC")
    else
      @articles = Article.paginate(:page => params[:page], :per_page => 15).order("pubdate DESC")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @articles, :callback => params[:callback]}
    end
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    @article = Article.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.json
  def new
    @article = Article.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = Article.find(params[:id])
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(params[:article])

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.json
  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :ok }
    end
  end
  
  def feed
    # this will be the name of the feed displayed on the feed reader
    @title = "Tech In Depth"
    
    # the news items
    @news_items = Article.order("pubdate desc")
    
    # this will be our Feed's update timestamp
    @updated = @news_items.first.pubdate unless @news_items.empty?
    
    respond_to do |format|
      format.atom { render :layout => false }
      
      # we want the RSS feed to redirect permanently to the ATOM feed
      format.rss { render :layout => false }
    end
  end
  
end
