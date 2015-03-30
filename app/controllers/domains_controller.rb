class DomainsController < ApplicationController
  before_action :set_domain, only: [:show, :edit, :update, :destroy]
  before_filter :login_required, :header_prerequisites
  skip_before_filter :login_required, :only => [:verified, :unapproved]
  
  # GET /domains
  # GET /domains.json
  def index
    @domains = Domain.all
  end

  # GET /domains/1
  # GET /domains/1.json
  def show
    @datas = DomainData.where(:domain_id => @domain.id )
  end

  # GET /domains/new
  def new
    @domain = Domain.new
    @scholarships = Scholarship.all
    @periods = Period.where(:activ => true)
  end

  # GET /domains/1/edit
  def edit
    @scholarships = Scholarship.all
    @datas = DomainData.where(:domain_id => @domain.id )
    @periods = Period.where(:activ => true)
  end

  # POST /domains
  # POST /domains.json
  def create
    @scholarships = Scholarship.all
    @domain = Domain.new(domain_params)
    @periods = Period.where(:activ => true)

    domain_data = params[:domain_data]

    respond_to do |format|
      if @domain.save
        # for i in 0..domain_data['name'].length - 1
        #   if domain_data['name'][i] != ""
        #     DomainData.create(:name => domain_data['name'][i], :sort => domain_data['sort'][i], :domain_id => @domain.id)
        #   end
        # end
        format.html { redirect_to "/periods", notice: 'Bursa a fost adaugata' }
        format.json { render action: 'show', status: :created, location: @domain }
      else
        format.html { render action: 'new' }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /domains/1
  # PATCH/PUT /domains/1.json
  def update
    @scholarships = Scholarship.all
    @periods = Period.where(:activ => true)
    domain_data = params[:domain_data]

    respond_to do |format|
      if @domain.update(domain_params)
        if !domain_data.nil?
          for i in 0..domain_data['name'].length - 1
            if domain_data['name'][i] != ""
              DomainData.create(:name => domain_data['name'][i], :sort => domain_data['sort'][i], :domain_id => @domain.id)
            end
          end
        end
        format.html { redirect_to @domain, notice: 'Domain was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /domains/1
  # DELETE /domains/1.json
  def destroy
    @domain.destroy
    respond_to do |format|
      format.html { redirect_to domains_url }
      format.json { head :no_content }
    end
  end


  def destroy_data
    @data = DomainData.find_by_id (params[:id])
    domain = @data.domain
    @data.destroy
    respond_to do |format|
      format.html { redirect_to :action => 'edit', :id => domain.id }
      format.json { head :no_content }
    end
  end

  def get_data
    @res = DomainData.where(:domain_id => params[:domain_id])
    render :json => @res
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_domain
      @domain = Domain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def domain_params
      params.require(:domain).permit(:name, :money, :order_number, :scholarship_id, :period_id, :an_studiu, :procent, :specializare )
    end

end
