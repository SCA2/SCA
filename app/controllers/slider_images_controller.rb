class SliderImagesController < ApplicationController
  
  before_action :signed_in_admin, except: :index
  before_action :set_slider_image, only: [:show, :edit, :update, :destroy]
  before_action :set_products

  # GET /images
  def index
    @slider_images = SliderImage.order(:id)
    respond_to do |format|
      format.html
      format.csv { render text: @slider_images.to_csv }
    end
  end

  # GET /images/1
  def show
  end

  # GET /images/new
  def new
    @slider_image = SliderImage.new
  end

  # GET /images/1/edit
  def edit
  end

  # POST /images
  def create
    @slider_image = SliderImage.new(slider_image_params)
    if @slider_image.save
      redirect_to @slider_image, notice: 'Slider image was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /images/1
  def update
    if @slider_image.update(slider_image_params)
      redirect_to @slider_image, notice: 'Slider image was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /images/1
  def destroy
    @slider_image.destroy
    redirect_to home_url
  end

  def import
    Faq.import(params[:file])
    redirect_to home_url, notice: "Slider images imported."
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slider_image
      @slider_image = SliderImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slider_image_params
      params.require(:slider_image).permit(:name, :caption, :url)
    end
    
    def set_products
      @products = Product.order(:category_weight, :model_weight)
    end
    
end
