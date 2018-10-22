namespace :db do
  desc "Copy product_category_ids to display_category_ids"
  task populate_display_category_ids: :environment do
    products = Product.all
    products.each do |product|
      product.update!(display_category_id: product.product_category_id)
    end
  end
end