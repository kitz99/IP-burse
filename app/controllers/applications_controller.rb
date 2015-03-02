class ApplicationsController < ApplicationController
  before_filter :login_required, :header_prerequisites
  
  
  # GET /applications
  def index
    respond_to do |format|
      format.html { redirect_to root_url , notice: 'You are not allowed there' }
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
    @application = Application.new
    
    @info = get_info

    @scholarship_id = params[:scholarship_id]
    @iban = @current_user.iban
    @bank = @current_user.bank

    @attachment = @application.attachments.build


    respond_to do |format|
      format.html 
    end
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

    @body = params[:api]
    
    if @body['is'].to_i == 1
      resp = send_info(@body)
    end

    check_scholarship = Scholarship.find_by_id params[:application]['scholarship_id']
    another_app = Application.where(scholarship_id: params[:application]['scholarship_id'], user_id: @current_user.id)

    # check permissions
    if check_scholarship.nil? || ! another_app.empty?
      respond_to do |format|
        format.html { redirect_to root_url , notice: 'You are not allowed there' }
      end
      return 
    end 

    app = Application.new
    app.reason = params[:application]['reason']
    app.status = "In asteptare"
    app.submission_date = Date.today.to_s
    app.user_id = @current_user.id
    app.scholarship_id = params[:application]['scholarship_id']
    app.on_card = params[:application]['on_card']

    respond_to do |format|
      if app.save
        if app.on_card == 1
          app.user.iban = params[:application][:users]['iban']
          app.user.bank = params[:application][:users]['bank']
          app.user.save
        end

        if params[:attachments]
          params[:attachments]['path'].each do |attachment|
            @attachment = app.attachments.create!(:path => attachment, :application_id => app.id, :name => File.basename(attachment.path))
          end
        end
        format.html { redirect_to app, notice: 'Application was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
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
  
  require 'net/http'
  require 'rest_client'
  require 'json'

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
