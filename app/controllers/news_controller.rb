class NewsController < ApplicationController
  before_action :set_news, only: [:show, :edit, :update, :destroy]
  before_filter :login_required, :header_prerequisites
  skip_before_filter :login_required, :only => [:verified, :unapproved]

  # GET /news/1
  # GET /news/1.json
  def show
  end

  def new
    @news = News.new
  end

  # POST /news
  # POST /news.json
  def create
    @news = News.new()
    @news.title = news_params["title"]
    @news.content = news_params["content"]
    @news.post_date = Time.now
    @news.user_id = @current_user.id
    if news_params["published"] == "true"
      @news.published = true
    else
      @news.published = false
    end

    username = @current_user.last_name
    @mailing_list = get_mailing_list

    respond_to do |format|
      if @news.save
        if @news.published == true
          NewsMailer.news_created(@news, username, @mailing_list).deliver_now
          format.html { redirect_to "/", notice: 'News was successfully published' }
          format.json { render action: 'show', status: :created, location: @news }
        else
          format.html { redirect_to "/", notice: 'News was successfully created and you can edit' }
          format.json { render action: 'show', status: :created, location: @news }
        end
      end
    end
  end

  def edit_unp
    @news = News.find(params[:news_id])
  end

  def post_edit
    news = News.find(params["news_id"])

    news.title = params["news"]["title"]
    news.content = params["news"]["content"]
    if params["news"]["published"] == "true"
      news.published = true
    else
      news.published = false
    end
    if news.save
      if news.published == true
       username = @current_user.last_name
       @mailing_list = get_mailing_list
       NewsMailer.news_created(news, username, @mailing_list).deliver_now
       redirect_to "/", notice: 'News was successfully published'
     else
      redirect_to "/review-news", notice: 'News was successfully updated'
    end
  end
end

def show_unpublished
  @unp_news = News.where(:published => false)
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

  def delete
    news = News.find(params[:news_id])
    news.destroy
    redirect_to "/review-news"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_news
      @news = News.find(params[:id])
      puts @news
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def news_params
      params.require(:news).permit(:title, :content, :post_date, :user_id, :published, :news_id)
    end

    def get_mailing_list

      students = JSON.parse RestClient.get "http://193.226.51.30/get_students?oauth_token=#{@current_user.token}", {:accept => :json}
      # incerc sa prelucrez studentii si sa scot emailurile intr-un array
      mailing_list = Array.new
      students.each do |year|
        year[1].each do |cycle|
          cycle[1].each do |group|
            group[1].each do |student|              
             mailing_list << student["email"]
           end
         end
       end
     end
     mailing_list << "tehnic@pddesign.ro"
     mailing_list << "bogdan.timofte@hotmail.com"
     mailing_list << "bogdan.mihai.timofte@gmail.com"
    #end try

    return mailing_list
  end

end
