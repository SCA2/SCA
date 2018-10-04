namespace :db do
  desc "Convert line_item from polymorphic to component"
  task convert_line_items: :environment do
    puts "Converting #{LineItem.count} line items"
    ActiveRecord::Base.transaction do
      LineItem.includes(:option).each do |i|
        i.update(component_id: i.option.component_id) if i.option && i.itemizable_type == 'Option'
        print "."
      end
      print "\n"
    end
    puts "Done!"
  end
end