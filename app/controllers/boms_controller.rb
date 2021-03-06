class BomsController < BaseController

  before_action :signed_in_admin

  def index
    @boms = Bom.all
  end

  def show
    @bc = BomCreator.new(bom_id)
  end

  def new
    @bc = BomCreator.new
  end

  def create
    @bc = BomCreator.new
    if @bc.save(bom_params)
      flash[:success] = "BOM #{@bc.bom_name} created"
      redirect_to @bc.bom
    else
      render 'new'
    end
  end

  def edit
    @bc = BomCreator.new(bom_id)
  end

  def update
    @bc = BomCreator.new(bom_id)
    if @bc.update(bom_params)
      flash[:success] = "BOM #{@bc.bom_name} updated"
      redirect_to edit_bom_path(@bc.id)
    else
      render 'edit'
    end
  end

  def new_item
    @bc = BomCreator.new(bom_id)
    @bc.new_item
  end

  def create_item
    @bc = BomCreator.new(bom_id)
    if @bc.update(bom_params)
      flash[:success] = "BOM #{@bc.bom_name} updated"
      redirect_to edit_bom_path(@bc.id)
    else
      render 'new_item'
    end
  end

  def destroy
    bom = Bom.find(bom_id)
    name = "#{bom.component.mfr_part_number}"
    bom.destroy
    redirect_to boms_path, notice: "BOM #{name} deleted"
  end

  def update_option
    @options = Product.find(params[:product_id]).options
    render json: @options.to_json
  end

private

  def bom_id
    params.require(:id)
  end

  def bom_params
    params.require(:bom_creator).permit(:root_component, :pdf, bom_items_attributes: [:id, :quantity, :reference, :component, :_destroy])
  end
end