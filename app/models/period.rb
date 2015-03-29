class Period < ActiveRecord::Base
	attr_accessible :start, :end, :buget, :activ, :nr_stud, :min_salary
	has_many :domain
    has_many :document
    
    validates_associated :domain
    validates :start, :end, :buget, :nr_stud, :min_salary, presence: true
    validates :buget, numericality: { only_integer: true }
    validates :min_salary, numericality: { only_integer: true}
    # validate :validate_dates

    # def validate_dates
    #     # puts "---------------#{:start}+++++++++++++++++54+++++++++++"
    #     errors.add(:eroare_perioada, ": Data de inceput trebuie sa fie precedenta datei de sfarsit") if :start > :end
    # end
end
