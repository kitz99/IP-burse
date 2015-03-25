class ApplicationsController < ApplicationController
  before_filter :login_required, :header_prerequisites
  
  
  # GET /applications
  def index
    respond_to do |format|
      format.html { redirect_to root_url , notice: 'You are not allowed there' }
    end
  end


  def inline_edit
    # metoda ce updateasa inline profilul utilizatorului
    # Iau din params ceea ce trebuie sa updatez
    # Verific daca se poate face update-ul si apoi incerc sa scriu in API

    nume = params['user']['last_name']
    prenume = params['user']['first_name']
    email = params['user']['email']
    iban = params['user']['iban']
    banca = params['user']['bank']
    bi_serie = params['user']['bi_serie']
    bi_numar = params['user']['bi_numar']

    user = current_user
    body = Hash.new
    b = false

    if not nume.nil?
      user.update_attributes(:last_name => nume)
      body["last_name"], b = nume, true
    end

    if not prenume.nil?
      user.update_attributes(:first_name => prenume)
      body["first_name"], b = prenume, true
    end

    if not email.nil?
      user.update_attributes(:email => email)
      body["email"], b = email, true
    end

    if not bi_serie.nil?
      body["ic_serie"], body["bi_serie"], b = bi_serie, bi_serie, true
    end

    if not bi_numar.nil?
      body["ic_number"], body["bi_numar"], b = bi_numar, bi_numar, true
    end

    if not iban.nil?
      if user.update_attributes(:iban => iban)
        body["pass"], body["iban"], b = "ok", iban, true
      end
    end

    if not banca.nil?
      if user.update_attributes(:bank=> banca)
        body["pass1"], body["bank"], b = "ok", banca, true
      end
    end

    respond_to do |format|
      if send_infos(body, user) == true
        format.json { render json: body }
      elsif (body["pass1"] = "ok" or body["pass"] = "ok") and b == false
        format.json { render json: body }
      else
        format.html { redirect_to "/logout" }
        format.json { head :no_content }
      end
    end

  end

  def get_for_generate
    if ! params[:domain_id] || !params[:not_users] || @current_user.is_admin != true
      render :json => ""
      return
    end

    domain_id = params[:domain_id]
    datas = DomainData.where(:domain_id => domain_id)
    i = 0
    join = ""
    order_by = ""
    not_in = params[:not_users]
    limit = ""


    datas.each do |p|
      join = join + " left join domain_data dd" + i.to_s + " on dd" + i.to_s + ".domain_id = d.id 
      left join application_extras ae" + i.to_s + " on a.id = ae" + i.to_s + ".application_id and ae" + i.to_s + ".domain_data_id = dd" + i.to_s + ".id"
      order_by = order_by + "ae" + i.to_s + ".value " + p.sort + ", "
      i = i + 1
    end

    if params[:limit]
      limit = " limit 0," + params[:limit].to_s
    end

    result = Application.find_by_sql("select distinct a.id, a.*, u.first_name || ' ' || u.last_name as username, ' ' as extra
      from applications a
      join users u on a.user_id = u.id
      join domains d on d.id = a.domain_id " + join + 
      " where a.domain_id = " + domain_id.to_s + 
      " and lower(a.status) like 'valida' 
      and u.id not in (" + not_in + ")
      order by " + order_by + " u.first_name asc " + limit)


    for i in 0..result.length - 1
      extras = ApplicationExtra.where(:application_id => result[i].id)
      result[i].extra = extras
    end 


    render :json => result
  end

  def get_waiting_applications
    if @current_user.is_admin != true
      render :json => ""
      return
    end
    applications = Application.find_by_sql("select * from applications where lower(status) like 'in asteptare'")
    render :json => applications
  end

  #pentru viitoare query-uri / momentan nefolosit
  def get_valid_applications
    if @current_user.is_admin != true
      render :json => ""
      return
    end
    applications = Application.find_by_sql("select * from applications where lower(status) like 'valida'")
    render :json => applications
  end

  def get_accepted_applications
    if @current_user.is_admin != true
      render :json => ""
      return
    end
    applications = Application.find_by_sql("select * from applications where lower(status) like 'acceptata'")
    render :json => applications
  end

  def get_applications
    if @current_user.is_admin != true
      render :json => ""
      return
    end
    applications = Application.all
    render :json => applications
  end


  def admin_show
    @application = Application.find_by_id params[:id]

    if @application.nil? || @current_user.is_admin != true
      respond_to do |format|
        format.html { redirect_to root_url , notice: 'You are not allowed there' }
      end
      return 
    end

    @user = @application.user
    @attachments = @application.attachments.all
    @domains = @application.scholarship.domain.all

    @implicitDomainData = []
    @application.application_extra.each do |p|
      @implicitDomainData.push(p.value)
    end

    respond_to do |format|
      format.html 
    end
  end

  def show
    @application = Application.find_by_id params[:id]
    
    if @current_user.is_admin == true
      respond_to do |format|
        format.html { redirect_to :action => "admin_show", :id => params[:id] }
      end
      return 
    end

    if check_permission(@application) == false
      return
    end

    @user = @current_user
    @attachments = @application.attachments.all

    respond_to do |format|
      format.html # show.html.erb
    end
  end


  def new
    @info = get_info
    @iban = @current_user.iban
    @bank = @current_user.bank

    period = Period.find_by(:activ =>true).id

    allScholarshipIds = Domain.select("scholarship_id").where(:period_id => period).uniq

    @scholarship_titles = Array.new

    allScholarshipIds.each do |elem|
      acte_cu_tilda =  Document.find_by(:period_id => period, :scholarship_id => elem.scholarship_id)

      if acte_cu_tilda 
        acte = acte_cu_tilda.name.split("~")
      end
      if not acte.nil?
        h = {"nume" => Scholarship.find_by(:id => elem.scholarship_id).stype, 
              "identificator" => rand(10000),
              "acte" => acte
            }
      else
         h = {"nume" => Scholarship.find_by(:id => elem.scholarship_id).stype, 
              "identificator" => rand(10000)
             }
      end

      @scholarship_titles << h
    end


    # respond_to do |format|
    #   format.html 
    # end
  end


  def edit

    @application = Application.find_by_id params[:id]

    if check_permission(@application) == false
      return
    end

    @attachments = @application.attachments.all

    str = "#{CUSTOM_PROVIDER_URL}/students/#{@current_user.uid}?oauth_token=#{@current_user.token}"

    @info = JSON.parse(open(str).read)

    if ! @info['error'].nil? 
      redirect_to root_url + 'logout'
    end

    @attachment = @application.attachments.build
  end



  def create
    # iau toate bursele si verific la care a aplicat
    # pentru fiecare tip de bursa la a aplicat, scot si documentele pe care tre sa le verific
    # pun totul in array-ul de hash-uri applied_at, care la campul type contine numele iar la campul papers contine actele necesare(array)

    # pentru fiecare act necesar din array-ul de mai sus, verific daca a incarcat. Daca e totul ok, linkez
    # datele comune cu datele astea particulare si creez o aplicatie. Daca nu, trec la urmatoarea, si retin erorile.

    # TODO - Urmeaza sa verific actele "incarcate", care sunt in inputuri de forma 'params[<nume_bursa>~<nume_act>]'
    
    period = Period.find_by(:activ =>true).id
    allScholarshipIds = Domain.select("scholarship_id").where(:period_id => period).uniq
    applied_at = Array.new()

    allScholarshipIds.each do |elem|
      could_apply_at = Scholarship.find_by(:id => elem.scholarship_id).stype
      
      if params[could_apply_at]["yes"] == "1"
        acte_cu_tilda =  Document.find_by(:period_id => period, :scholarship_id => elem.scholarship_id)

        if acte_cu_tilda 
          acte = acte_cu_tilda.name.split("~")
        end

        applied_at << {
          "type" => could_apply_at,
          "papers" => acte
        }
      end
    end


    

    # puts "================================================="
    #   applied_at.each do |a|
    #     puts "A aplicat la #{a['type']} si tre sa verific actele: #{a['papers']}"
    #     puts "------------------------------------------------------------------"
    #   end
    # puts "================================================="





    # user = current_user
    # str = "#{CUSTOM_PROVIDER_URL}/students/#{current_user.uid}?oauth_token=#{current_user.token}"

    # info = JSON.parse(open(str).read)

    # if ! info['error'].nil? 
    #   redirect_to root_url + 'logout'
    # end

    # submission_date = Date.today.to_s
    # status = "In asteptare"
    # reason =  params[:application]['reason']
    # scholarship_id =
    # user_id = @current_user.id
    # on_card = params[:application]['on_card']
    # domain_id = session["aplic_id"]



    # @body = params[:api]
    
    # if @body['is'].to_i == 1
    #   resp = send_info(@body)
    # end

    # check_scholarship = Scholarship.find_by_id params[:application]['scholarship_id']
    # another_app = Application.where(scholarship_id: params[:application]['scholarship_id'], user_id: @current_user.id)

    # # check permissions
    # if check_scholarship.nil? || ! another_app.empty?
    #   respond_to do |format|
    #     format.html { redirect_to root_url , notice: 'You are not allowed there' }
    #   end
    #   return 
    # end 

    # app = Application.new
    # app.reason = params[:application]['reason']
    # app.status = "In asteptare"
    # app.submission_date = Date.today.to_s
    # app.user_id = @current_user.id
    # app.scholarship_id = params[:application]['scholarship_id']
    # app.on_card = params[:application]['on_card']

    # respond_to do |format|
    #   if app.save
    #     if app.on_card == 1
    #       app.user.iban = params[:application][:users]['iban']
    #       app.user.bank = params[:application][:users]['bank']
    #       app.user.save
    #     end

    #     if params[:attachments]
    #       params[:attachments]['path'].each do |attachment|
    #         @attachment = app.attachments.create!(:path => attachment, :application_id => app.id, :name => File.basename(attachment.path))
    #       end
    #     end
    #     format.html { redirect_to app, notice: 'Application was successfully created.' }
    #   else
    #     format.html { render action: "new" }
    #   end
    # end
    redirect_to "/"
  end


  def update

    @body = params[:api]

    if ! @body.nil? && @body['is'].to_i == 1
      resp = send_info(@body)
    end

    application = Application.find_by_id params[:id]

    if check_permission(application) == false 
      return
    end

    if @current_user.is_admin == false

      application.on_card = params[:application]['on_card']
      application.submission_date = Date.today.to_s
      application.status = "In asteptare"

      if application.on_card == 1
        application.user.iban = params[:application][:users]['iban']
        application.user.save
      else
        application.reason = params[:application]['reason']
      end

      if params[:attachments]
        params[:attachments]['path'].each do |attachment|
          @attachment = application.attachments.create!(:path => attachment, :application_id => application.id, :name => File.basename(attachment.path))
        end
      end
    else
      status = params[:application]['status']


      if status.to_i == 1
        application.status = "Valida"
        application.domain_id = params[:application]['domain_id']

        extra = params[:data]

        application.application_extra.destroy_all

        for i in 0..extra['value'].length - 1
          if extra['value'][i] != ""
            ApplicationExtra.create(:value => extra['value'][i], :application_id => application.id, :domain_data_id => extra['id'][i])
          end
        end

      else
        application.status = "Nevalida"
        application.response = params[:application]['response']
      end

    end

    if application.save
      redirect_to application, notice: 'Application was updated'
    else
      redirect_to application, notice: 'failed.' 
    end
    return 

  end



  def destroy
    @application = Application.find(params[:id])
    @application.destroy

    respond_to do |format|
      format.html { redirect_to applications_url }
    end
  end


  private

  def get_scholarships_for_active_period
    period = Period.find_by(:activ =>true).id
    return Domain.select("scholarship_id").where(:period_id => period).uniq
  end
  
  require 'net/http'
  require 'rest_client'
  require 'json'


  def send_infos (b, user) 
    # Metoda care trimite jsonul catre repo pentru update
    # Metoda verifica raspunsul primit si returneaza un mesaj ca atare

    if b.nil?
      return false
    end

    url = "#{CUSTOM_PROVIDER_URL}/update_stud/#{user.uid}?oauth_token=#{user.token}"
    body = b.to_json
    
    response = JSON.parse(RestClient.post url, body, {:content_type => :json})

    # puts "Mesajul de la repo-------------------> #{response}"

    if response['message'] == "error while updating student"
      return false
    end

    return true
  end

  def get_info 
    str = "#{CUSTOM_PROVIDER_URL}/students/#{@current_user.uid}?oauth_token=#{@current_user.token}"

    info = JSON.parse(open(str).read)

    if ! info['error'].nil? 
      redirect_to root_url + 'logout'
      return
    end
    return info
  end

  def send_info (b) 
    url = "#{CUSTOM_PROVIDER_URL}/update_stud/#{@current_user.uid}?oauth_token=#{@current_user.token}"
    body = b.to_json
    
    response = RestClient.post url, body, {:content_type => :json} 


    response = JSON.parse(response)

    if response['message'] == "error while updating student"
      return false
    end

    return true
  end

  def check_permission(app)  

    # check permissions
    if app.nil? || (app.user.id != @current_user.id && @current_user.is_admin == false)
      respond_to do |format|
        format.html { redirect_to root_url , notice: 'You are not allowed there' }
      end
      return false
    end 

    return true
  end

  



end
