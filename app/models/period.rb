class Period < ActiveRecord::Base
	attr_accessible :start, :end, :buget, :activ, :nr_stud, :min_salary
	has_many :domain
end
