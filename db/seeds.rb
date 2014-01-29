# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

Faq.delete_all
CSV.foreach('NewFAQ.csv', 'r') do |faq|
  group, question, answer = faq[0], faq[1], faq[2]
  Faq.create(:group => group, :question => question, :answer => answer)
end
