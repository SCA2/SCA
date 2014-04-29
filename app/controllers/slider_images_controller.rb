class SliderImagesController < ApplicationController
  
  include CurrentCart, SidebarData
  before_action :set_cart, :set_products
  
  before_action :signed_in_admin
  before_action :set_slider_image, only: [:update, :destroy]

  def index
    @slider_images = SliderImage.order(:id)
  end

  def new
    @slider_image = SliderImage.new
  end

  def create
    @slider_image = SliderImage.new(slider_image_params)
    if @slider_image.save
      redirect_to @slider_image, notice: 'Slider image was successfully created.'
    else
      render 'new'
    end
  end

  def update
    if @slider_image.update(slider_image_params)
      redirect_to slider_images_url, notice: 'Slider image ' + @slider_image.id.to_s + ' was successfully updated.'
    else
      render 'index', alert: 'Unable to update slider image ' + @slider_image.id.to_s
    end
  end

  def destroy
    @slider_image.destroy
    redirect_to slider_images_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slider_image
      @slider_image = SliderImage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slider_image_params
      params.require(:slider_image).permit(:name, :caption, :image_url, :product_url, :sort_order)
    end
    
end
