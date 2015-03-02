class ScholarshipsController < ApplicationController
  before_filter :login_required, :header_prerequisites
  skip_before_filter :login_required, :only => [:verified, :unapproved]

  
  # GET /scholarships
  # GET /scholarships.json
  def index
    @scholarships = Scholarship.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scholarships }
    end
  end

  # GET /scholarships/1
  # GET /scholarships/1.json
  def show
    @scholarship = Scholarship.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scholarship }
    end
  end

  # GET /scholarships/new
  # GET /scholarships/new.json
  def new
    @scholarship = Scholarship.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scholarship }
    end
  end

  # GET /scholarships/1/edit
  def edit
    @scholarship = Scholarship.find(params[:id])
  end

  # POST /scholarships
  # POST /scholarships.json
  def create
    @scholarship = Scholarship.new(params[:scholarship])

    respond_to do |format|
      if @scholarship.save
        format.html { redirect_to @scholarship, notice: 'Scholarship was successfully created.' }
        format.json { render json: @scholarship, status: :created, location: @scholarship }
      else
        format.html { render action: "new" }
        format.json { render json: @scholarship.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scholarships/1
  # PUT /scholarships/1.json
  def update
    @scholarship = Scholarship.find(params[:id])

    respond_to do |format|
      if @scholarship.update_attributes(params[:scholarship])
        format.html { redirect_to @scholarship, notice: 'Scholarship was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @scholarship.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scholarships/1
  # DELETE /scholarships/1.json
  def destroy
    @scholarship = Scholarship.find(params[:id])
    @scholarship.destroy

    respond_to do |format|
      format.html { redirect_to scholarships_url }
      format.json { head :no_content }
    end
  end
end
