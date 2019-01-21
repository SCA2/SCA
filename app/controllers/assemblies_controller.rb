class AssembliesController < BaseController

  before_action :signed_in_admin

  def edit
    @component = Component.find(params[:component_id])
    @bom = Bom.find(params[:id])
  end

  def update
    @component = Component.find(params[:component_id])
    if @component.make_assemblies!(quantity: assemblies_to_make)
      redirect_to components_path, notice: "Component #{@component.mfr_part_number} assemblies updated"
    else
      render 'edit'
    end
  end

private

  def assemblies_to_make
    params.require(:component).permit(:restock_quantity)[:restock_quantity].to_i
  end

end