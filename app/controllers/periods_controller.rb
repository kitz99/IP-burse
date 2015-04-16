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
    str = "http://193.226.51.30/students/count?oauth_token=#{current_user.token}"

    @info = JSON.parse(open(str).read)
    @period.nr_stud = @info["count"]
  end

  # GET /periods/1/edit
  def edit
  end

  # POST /periods
  # POST /periods.json
  def create
    @period = Period.new(period_params)

    if @period.start < @period.end

      respond_to do |format|
        verify_activ = Period.find_by(:activ => 't')
        if not verify_activ.nil?
          flash[:error] = "Exista deja o perioada activa!"
          format.html { redirect_to "/periods/new", error: 'Exista deja o perioada activa!' }
        else
          if @period.save
            # create a news when a period is started
            @news = News.new()
            @news.title = "Sesiune noua de burse"
            @news.content = "A fost deschisa o sesiune noua de aplicare la burse. Perioada incepe la #{@period.start} si se termina la #{@period.end}"
            @news.post_date = Time.now
            @news.published = true
            @news.user_id = @current_user.id

            username = @current_user.last_name
            @mailing_list = Array.new

            @students = JSON.parse RestClient.get "http://193.226.51.30/get_students?oauth_token=#{@current_user.token}", {:accept => :json}
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
             format.html { redirect_to "/periods", notice: 'Period was successfully created.' }
             format.json { render :show, status: :created, location: @period }
           else
            format.html { render :new }
            format.json { render json: @period.errors, status: :unprocessable_entity }
          end
        end
      end
    else
      flash[:error] = "Data de inceput trebuie sa fie precedenta datei de sfarsit!"
      respond_to do |format|
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

  def delete
    period = Period.find(params[:per_id])

    if period.activ == false
      flash[:notice] = "Sesiunea a fost stearsa cu succes"
      period.destroy
      redirect_to '/periods'
    else
      flash[:notice] = "Sesiunea este activa in momentul de fata si nu poate fi stearsa"
      redirect_to '/periods'
    end
  end

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
    domain = Domain.new(domain_params)
    noDoc = params[:NrDoc].to_i
    docs = ""
    template = "doc"
    doci = ""
    noDoc.times do | i |
      doci = template + i.to_s
      docs = docs +  params[:"#{doci}"] + "~"
    end

    
    documents = Document.new
    documents.name = docs
    documents.period_id = domain.period_id
    documents.scholarship_id = domain.scholarship_id
    documents.save

    flash[:notice] = "Ati definit actele necesare pentru acest tip de bursa." 
    redirect_to "/config-scholarship"
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

    def domain_params
      params.require(:domain).permit(:scholarship_id, :period_id)
    end
  end
