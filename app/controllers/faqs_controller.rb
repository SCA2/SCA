class FaqsController < ApplicationController
  
  before_action :signed_in_admin, except: :index
  before_action :set_faq, only: [:show, :edit, :update, :destroy]

  # GET /faqs
  def index
    @ordering_faqs = Faq.where(group: 'Ordering')
    @general_faqs = Faq.where(group: 'General')
    @assembly_faqs = Faq.where(group: 'Assembly')
    @support_faqs = Faq.where(group: 'Support')
  end

  # GET /faqs/1
  def show
  end

  # GET /faqs/new
  def new
    @faq = Faq.new
  end

  # GET /faqs/1/edit
  def edit
  end

  # POST /faqs
  def create
    @faq = Faq.new(faq_params)
    if @faq.save
      redirect_to @faq, notice: 'Faq was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /faqs/1
  def update
    if @faq.update(faq_params)
      redirect_to @faq, notice: 'Faq was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /faqs/1
  def destroy
    @faq.destroy
    redirect_to faqs_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faq
      @faq = Faq.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def faq_params
      params.require(:faq).permit(:group, :question, :answer, :priority)
    end
    
    def signed_in_admin
      unless signed_in? && current_user.admin?
        redirect_to faqs_url, :notice => "Sorry, admins only!"
      end
    end

end
