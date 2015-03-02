# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#initial values
Scholarship.create([{ stype: 'Bursa de performanta' }, { stype: 'Bursa de merit/studiu' }, { stype: 'Bursa sociala' }, { stype: 'Bursa sociala ocazionala' }])

Domain.create ([
  {:name => 'Sociala 12', :money => 3600, :order_number => 4, :scholarship_id => 3}, 
  {:name => 'Sociala 9', :money => 2700, :order_number => 1, :scholarship_id => 3}, 
  {:name => 'Info performanta an2', :money => 5400, :order_number => 5, :scholarship_id => 1}, 
  {:name => 'Info performanta an3', :money => 5400, :order_number => 5, :scholarship_id => 1}, 
  {:name => 'Info performanta master1', :money => 5400, :order_number => 5, :scholarship_id => 1}, 
  {:name => 'Info performanta master2', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'Info merit an1', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Info merit an2', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Info merit an3', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Info merit master1', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Info merit master2', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Info studiu an1', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'Info studiu an2', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'Info studiu an3', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'Info studiu master1', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'Info studiu master2', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'Mate performanta an2', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'Mate performanta an3', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'Mate performanta an4', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'Mate performanta master1', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'Mate performanta master2', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'Mate merit an1', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Mate merit an2', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Mate merit an3', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Mate merit an4', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Mate merit master1', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Mate merit master2', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'Mate studiu an1', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'Mate studiu an2', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'Mate studiu an3', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'Mate studiu an4', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'Mate studiu master1', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'Mate studiu master2', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'TI performanta an2', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'TI performanta an3', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'TI performanta an4', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'TI performanta master1', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'TI performanta master2', :money => 5400, :order_number => 5, :scholarship_id => 1},
  {:name => 'TI merit an1', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'TI merit an2', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'TI merit an3', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'TI merit an4', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'TI merit master1', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'TI merit master2', :money => 3600, :order_number => 3, :scholarship_id => 2},
  {:name => 'TI studiu an1', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'TI studiu an2', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'TI studiu an3', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'TI studiu an4', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'TI studiu master1', :money => 3150, :order_number => 2, :scholarship_id => 2},
  {:name => 'TI studiu master2', :money => 3150, :order_number => 2, :scholarship_id => 2}
  ])
