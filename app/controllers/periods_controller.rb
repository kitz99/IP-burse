class PeriodsController < ApplicationController
  before_filter :login_required, :header_prerequisites
  before_action :set_period, only: [:show, :edit, :update, :destroy]

  # GET /periods
  # GET /periods.json
  def index
    @periods = Period.all
    @all_scholarships = Array.new
    @periods.each do |p|
      @all_scholarships << {"sesiune" => p, "burse" => Domain.where(:period_id => p.id)}
    end
  end

  # GET /periods/1
  # GET /periods/1.json
  def show
  end

  # GET /periods/new
  def new
    @period = Period.new
  end

  # GET /periods/1/edit
  def edit
  end

  # POST /periods
  # POST /periods.json
  def create
    @period = Period.new(period_params)

    respond_to do |format|
      if @period.save
        # create a news when a period is started
        @news = News.new()
        @news.title = "Sesiune noua de burse"
        @news.content = "A fost deschisa o sesiune noua de aplicare la burse. Perioada incepe la #{@period.start} si se termina la #{@period.end}"
        @news.post_date = Time.now
        @news.user_id = @current_user.id

        username = @current_user.last_name
        @mailing_list = Array.new

        @students = JSON.parse RestClient.get "http://fmi-api.herokuapp.com/get_students?oauth_token=#{@current_user.token}", {:accept => :json}
          # incerc sa prelucrez studentii si sa scot emailurile intr-un array
          @students.each do |year|
            year[1].each do |cycle|
              cycle[1].each do |group|
                group[1].each do |student|              
                 @mailing_list << student["email"]
               end
             end
           end
          end
          @mailing_list << "tehnic@pddesign.ro"
          @mailing_list << "bogdan.timofte@hotmail.com"
          @mailing_list << "bogdan.mihai.timofte@gmail.com"

        NewsMailer.news_created(@news, username, @mailing_list).deliver_now
        @news.save()
        format.html { redirect_to @period, notice: 'Period was successfully created.' }
        format.json { render :show, status: :created, location: @period }
      else
        format.html { render :new }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /periods/1
  # PATCH/PUT /periods/1.json
  def update
    respond_to do |format|
      if @period.update(period_params)
        format.html { redirect_to @period, notice: 'Period was successfully updated.' }
        format.json { render :show, status: :ok, location: @period }
      else
        format.html { render :edit }
        format.json { render json: @period.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /periods/1
  # DELETE /periods/1.json
  def destroy
    @period.destroy
    respond_to do |format|
      format.html { redirect_to periods_url, notice: 'Period was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def defineScholarship
    @domain = Domain.new
    @scholarships = Scholarship.all    
    @periods = Period.all
  end

  def defineDocumentsForScholarship
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_period
      @period = Period.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def period_params
      params.require(:period).permit(:start, :end, :buget, :activ, :nr_stud, :min_salary)
    end
end
