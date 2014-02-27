class FaqsController < ApplicationController
  
  before_action :signed_in_admin, except: :index
  before_action :set_faq, only: [:show, :edit, :update, :destroy]

  # GET /faqs
  def index
    @category = Faq.select(:category).distinct.order(:category_weight)
    @faqs = Faq.order(:question_weight)
    respond_to do |format|
      format.html
      format.csv { render text: @faqs.to_csv }
    end
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

  def import
    Faq.import(params[:file])
    redirect_to faqs_url, notice: "FAQs imported."
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_faq
      @faq = Faq.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def faq_params
      params.require(:faq).permit(:category, :category_weight, :question, :question_weight, :answer)
    end
    
end
