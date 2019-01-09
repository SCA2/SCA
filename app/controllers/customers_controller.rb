class CustomersController < BaseController

  before_action :admin_user, only: [:index, :registered, :guests]
  
  def index
    @customers = Order.customers.includes(:addresses)
    respond_to do |format|
      format.html
      format.csv { send_data create_csv(@customers), filename: "all-customers-#{Date.today}" }
    end
  end

  def registered
    @customers = Order.customers.includes(:addresses).where(email: User.pluck(:email))
    respond_to do |format|
      format.html { render 'index' }
      format.csv { send_data create_csv(@customers), filename: "registered-customers-#{Date.today}" }
    end
  end
  
  def guests
    @customers = Order.customers.includes(:addresses).where.not(email: User.pluck(:email))
    respond_to do |format|
      format.html { render 'index' }
      format.csv { send_data create_csv(@customers), filename: "guest-customers-#{Date.today}" }
    end
  end
  
  private

    def admin_user
      unless signed_in_admin?
        flash[:alert] = 'Sorry, admins only'
        redirect_to(home_path)
      end
    end

    def create_csv(customers)
      CSV.generate(headers: true) do |csv|
        csv << %w{email name created_at}
        customers.each do |customer|
          name = "#{customer.billing_address.first_name} #{customer.billing_address.last_name}"
          csv << [customer.email] + [name] + [customer.created_at]
        end
      end
    end



end

