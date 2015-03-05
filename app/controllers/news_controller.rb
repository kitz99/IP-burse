class NewsController < ApplicationController
  before_action :set_news, only: [:show, :edit, :update, :destroy]
  before_filter :login_required, :header_prerequisites
  skip_before_filter :login_required, :only => [:verified, :unapproved]

  # GET /news/1
  # GET /news/1.json
  def show 
  end


  # POST /news
  # POST /news.json
  def create
    @news = News.new()
    @news.title = news_params["title"]
    @news.content = news_params["content"]
    @news.post_date = Time.now
    @news.user_id = @current_user.id

    username = User.find(@news.user_id).last_name
    respond_to do |format|
      if @news.save
        # here send mail
        NewsMailer.news_created(@news, username).deliver
        format.html { redirect_to @news, notice: 'News was successfully created.' }
        format.json { render action: 'show', status: :created, location: @news }
      end
    end
  end

  # PATCH/PUT /news/1
  # PATCH/PUT /news/1.json
  def update
    respond_to do |format|
    @news.title = news_params["title"]
    @news.content = news_params["content"]
    @news.user_id = @current_user.id
      if @news.save
        format.html { redirect_to @news, notice: 'News was successfully updated.' }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /news/1
  # DELETE /news/1.json
  def destroy
    @news.destroy
    respond_to do |format|
      format.html { redirect_to news_index_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_params
      params.require(:news).permit(:title, :content, :post_date, :user_id)
    end
  end
