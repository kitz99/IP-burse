class HomeController < ApplicationController
  before_filter :login_required, :header_prerequisites
  skip_before_filter :login_required, :only => [:verified, :unapproved]


  def index

    @allnews = News.where(:published => true).order('post_date DESC')

    if @current_user.is_admin == true 
      respond_to do |format| 
        format.html { redirect_to '/admin' } 
      end
    end

    if @current_user.is_student == true
      respond_to do |format|
        format.html # index.html.erb
      end
    end
  end

  def admin_resolved

  end

  def admin_index
    @allnews = News.where(:published => true).order('post_date DESC')

    if @current_user.is_student == true
      respond_to do |format|
        format.html { redirect_to '/' }
      end
    end

    if @current_user.is_admin == true
      respond_to do |format|
        format.html # admin.html.erb
      end
    end

  end

  def delete_all
    if @current_user.is_admin == true
      flash[:notice] = "Incep sa sterg: "
      begin
        Application.destroy_all
        flash[:notice] += "STERS - Applications | "
      rescue Exception => e
        flash[:notice] += "NU POT - Applications | "
      end
      begin
        Document.destroy_all
        flash[:notice] += "STERS - Documents | "
      rescue Exception => e
        flash[:notice] += "NU POT - Applications | "
      end
      begin
        Period.destroy_all
        flash[:notice] += "STERS - Periods | "
      rescue Exception => e
        flash[:notice] += "NU POT - Periods | "
      end
      begin
        Paper.destroy_all
        flash[:notice] += "STERS - Papers | "
      rescue Exception => e
        flash[:notice] += "NU POT - Papers | "
      end
      begin
        News.destroy_all
        flash[:notice] += "STERS - news | "
      rescue Exception => e
        flash[:notice] += "NU POT - News | "
      end
      begin
        Domain.destroy_all
        flash[:notice] += "STERS - Domain | "
      rescue Exception => e
        flash[:notice] += "NU POT - Domain | "
      end
      
      redirect_to "/"
    else
      redirect_to "/logout"
    end
  end


  def generate
    @domains = Domain.order(order_number: :desc)

    seat_numbers = students_numbers()

    @initial_numbers = []


    @domains.each do |p|
      puts p.inspect
      puts 'aaaaaaaaaa'

      app_number = p.application.where("lower(status) like 'valida'").count

      if p.order_number >= 3
        @initial_numbers[p.id] = app_number
      elsif p.order_number == 2
        seats = get_seat_nr_for_id(p.id, seat_numbers)

        if seats != -1
          @initial_numbers[p.id] = [seats, app_number].min
        else
          @initial_numbers[p.id] = app_number
        end
      end
    end

  end


  def admin_requests

    if @current_user.is_admin != true
      respond_to do |format|
        format.html { redirect_to '/' }
      end
    end

    respond_to do |format|
      format.json { render json: AllDatatable.new(view_context) }
      format.html # admin_requests.html.erb
    end
  end


  def admin_waiting

    if @current_user.is_admin != true
      respond_to do |format|
        format.html { redirect_to '/' }
      end
    end

    respond_to do |format|
      format.json { render json: WaitingDatatable.new(view_context) }
      format.html # admin_requests.html.erb
    end
  end

  def admin_valid

    if @current_user.is_admin != true
      respond_to do |format|
        format.html { redirect_to '/' }
      end
    end

    respond_to do |format|
      format.json { render json: ValidDatatable.new(view_context) }
      format.html # admin_valid.html.erb
    end
  end

  def datatable_i18n
    locale = {
      "sProcessing" =>   "Proceseaza...",
      "sLengthMenu" =>   "Afiseaza _MENU_ inregistrari pe pagina",
      "sZeroRecords" =>  "Nu am gasit nimic - ne pare rau",
      "sInfo" =>         "Afisate de la _START_ la _END_ din _TOTAL_ inregistrari",
      "sInfoEmpty" =>    "Afisate de la 0 la 0 din 0 inregistrari",
      "sInfoFiltered" => "(filtrate dintr-un total de _MAX_ inregistrari)",
      "sInfoPostFix" =>  "",
      "sSearch" =>       "Cauta:",
      "sUrl" =>        "",
      "oPaginate" => {
        "sFirst" =>   "Prima",
        "sPrevious" => "Precedenta",
        "sNext" =>     "Urmatoarea",
        "sLast" =>    "Ultima"
      }
    }
    render :json => locale
  end

  helper_method :datatable_i18n

  private

  def students_numbers

    str = "#{CUSTOM_PROVIDER_URL}/groups?oauth_token=#{@current_user.token}"
    info = JSON.parse(open(str).read)


    if ! info['error'].nil?
      redirect_to root_url + 'logout'
      return
    end

    res = Hash.new

    info.each do |x|
      y = x[1]

      if ! res[y['domeniu']].nil? && ! res[y['domeniu']][y['an']].nil?
        res[y['domeniu']][y['an']] += y['numar_studenti']
      elsif ! res[y['domeniu']].nil?
        res[y['domeniu']][y['an']] = y['numar_studenti']
      else
        res[y['domeniu']] = []
      end
    end

    return res
  end

  def get_seat_nr_for_id(id, seats)
    if not [12, 13, 14, 15, 16, 28, 29, 30, 31, 32, 33, 45, 46, 47, 48, 49, 50].include?(id)
      return -1
    end

    #info
    if [12, 13, 14, 15, 16].include?(id)  && ! seats['Informatica'].nil? && ! seats['Informatica'][id - 11].nil?
      return (seats['Informatica'][id - 11] * 0.2).to_i
    end

    #mate
    if [28, 29, 30, 31, 32, 33].include?(id) && ! seats['Matematica'].nil? && ! seats['Matematica'][id - 27].nil?
      return (seats['Matematica'][id - 27] * 0.2).to_i
    end

    #cti
    if [45, 46, 47, 48, 49, 50].include?(id) && ! seats['cti'].nil? && ! seats['cti'][id - 44].nil?
      return (seats['cti'][id - 44] * 0.2).to_i
    end

    return -1

  end
end
