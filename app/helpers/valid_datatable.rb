class ValidDatatable
  delegate :params, :link_to,to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Application.where("lower(status) like 'valida'").count,
      iTotalDisplayRecords: valid.total_entries,
      aaData: data
    }
  end

private

  def data
    valid.map do |application|
      [
        ERB::Util.h(application.user.last_name),
        ERB::Util.h(application.user.first_name),
        ERB::Util.h(application.scholarship.stype),
        ERB::Util.h(link_to 'Click', application, target: "_blank")
      ]
    end
  end

  def valid
    @valid ||= fetch_valid
  end

  def fetch_valid
    valid = Application.joins(:user).joins(:scholarship).where("lower(applications.status) like 'valida'").order("#{sort_column} #{sort_direction}")
    valid = valid.page(page).per_page(per_page)
    if params[:sSearch].present?
      valid = valid.where("users.first_name like :search or users.last_name like :search or scholarships.stype like :search", search: "%#{params[:sSearch]}%")
    end
    valid
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[users.last_name users.first_name scholarships.stype ]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end