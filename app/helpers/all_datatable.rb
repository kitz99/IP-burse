class AllDatatable
  delegate :params, :link_to, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords:  Application.count,
      iTotalDisplayRecords: all.total_entries,
      aaData: data
    }
  end

private

  def data
     all.map do |application|
      [
        ERB::Util.h(application.user.last_name),
        ERB::Util.h(application.user.first_name),
        ERB::Util.h(application.scholarship.stype),
        ERB::Util.h(application.status),
        ERB::Util.h(link_to 'Click', application, target: "_blank")
      ]
    end
  end

  def all
    @all ||= fetch_all
  end

  def fetch_all
    all = Application.joins(:user).joins(:scholarship).order("#{sort_column} #{sort_direction}")
    all = all.page(page).per_page(per_page)
    if params[:sSearch].present?
      all = all.where("users.first_name like :search or users.last_name like :search or scholarships.stype like :search", search: "%#{params[:sSearch]}%")
    end
    all
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[users.last_name users.first_name scholarships.stype]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end