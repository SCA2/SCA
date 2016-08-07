class SliderImagesController < BaseController
  
  before_action :signed_in_admin

  def index
    @slider_images = SliderImage.order(:id)
  end

  def new
    @slider_image = SliderImage.new
  end

  def create
    @slider_image = SliderImage.new(slider_image_params)
    if @slider_image.save
      redirect_to slider_images_url, notice: 'Slider image ' + @slider_image.id.to_s + ' was successfully created.'
    else
      render 'new'
    end
  end

  def update
    if slider_image.update(slider_image_params)
      redirect_to slider_images_url, notice: 'Slider image ' + @slider_image.id.to_s + ' was successfully updated.'
    else
      render 'index', alert: 'Unable to update slider image ' + @slider_image.id.to_s
    end
  end

  def destroy
    slider_image.destroy
    redirect_to slider_images_url
  end

  private
    def slider_image
      @slider_image ||= SliderImage.find(params[:id])
    end

    def slider_image_params
      params.require(:slider_image).permit(:name, :caption, :image_url, :product_url, :sort_order)
    end
    
end
