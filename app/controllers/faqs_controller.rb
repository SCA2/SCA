class FaqsController < BaseController
  
  before_action :signed_in_admin, except: :index

  helper_method :faq, :categories

  def index
  end

  def new
    @faq = Faq.next_faq
  end

  def edit
  end

  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      flash[:success] = "Success! Faq #{@faq.question_weight} created."
      redirect_to new_faq_path
    else
      render 'new'
    end
  end

  def update
    if faq.update(faq_params)
      flash[:success] = "Success! Faq #{@faq.question_weight} updated."
      redirect_to faqs_path
    else
      render 'edit'
    end
  end

  def destroy
    faq.destroy
    redirect_to faqs_url
  end

  def categories
    @categories ||= FaqsCategory.order(:category_weight)
  end

  def faq
    @faq ||= Faq.find(params[:id])
  end

  private

    def faq_params
      params.require(:faq).permit(:faqs_category_id, :question, :question_weight, :answer)
    end
    
end
