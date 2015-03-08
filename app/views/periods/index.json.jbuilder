json.array!(@periods) do |period|
  json.extract! period, :id, :start, :end, :buget, :activ, :nr_stud, :min_salary
  json.url period_url(period, format: :json)
end
