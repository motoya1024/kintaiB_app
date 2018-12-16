# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(1..6).each do |n|
  arrival_time  = Time.zone.local(2018,12,n,11,25)
  leaving_time  = Time.zone.local(2018,12,n,14,36)
  user_id = 6
  Timecard.create!(arrival_time:  arrival_time,
               leaving_time: leaving_time,
               user_id: user_id
               )
end

