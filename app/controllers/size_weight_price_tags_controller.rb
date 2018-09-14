class SizeWeightPriceTagsController < BaseController

  before_action :signed_in_admin

  def new
    @component = Component.find(params.require(:component_id))
    @tag = SizeWeightPriceTag.new
  end

  def edit
    @component = Component.find(params.require(:component_id))
    @tag = @component.size_weight_price_tag
  end

  def show
    @component = Component.find(params.require(:component_id))
    @tag = @component.size_weight_price_tag
    render action: 'edit'
  end

  def create
    @component = Component.find(params.require(:component_id))
    @tag = @component.build_size_weight_price_tag(tag_params)
    if @tag.save
      flash[:notice] = "Success! Tag #{ @tag.id } created."
      redirect_to @component
    else
      render action: 'new'
    end
  end

  def update
    @tag = SizeWeightPriceTag.find(params.require(:id))
    @tag.update(tag_params)
    if @tag.save
      flash[:notice] = "Success! Tag #{ @tag.id } updated."
      redirect_to @tag.component
    else
      render action: 'edit'
    end
  end

  def destroy
    @tag = SizeWeightPriceTag.find(params.require(:id))
    @component = @tag.component
    @tag.destroy
    flash[:notice] = "Success! Tag #{@tag.id} deleted."
    redirect_to @component
  rescue(ActiveRecord::DeleteRestrictionError)
    carts = Cart.where(id: @tag.line_items.pluck(:cart_id))
    orders = Order.joins(:cart).where(cart_id: carts)
    options = @tag.options
    if orders.count > 0
      alert = "Tag #{@tag.id} is referenced by order #{orders.first.id} and #{orders.count - 1} others. Delete those first."
    elsif carts.count > 0
      alert = "Tag #{@tag.id} is referenced by cart #{carts.first.id} and #{carts.count - 1} others. Delete those first."
    elsif options.count > 0
      alert = "Tag #{@tag.id} is referenced by product option #{options.first.id} and #{options.count - 1} others. Delete those first."
    else
      alert = "Can't delete this tag because of DeleteRestrictionError."
    end
    redirect_to @component, alert: alert
  end

private

  def tag_params
    params.require(:size_weight_price_tag).permit(:upc, :full_price, :discount_price, :shipping_length, :shipping_width, :shipping_height, :shipping_weight)
  end

end
