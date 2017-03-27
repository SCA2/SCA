class ComponentImportsController < BaseController
  def new
    @component_import = ComponentImporter.new
  end

  def create
    @component_import = ComponentImporter.new(import_params)
    if @component_import.save
      redirect_to components_url, notice: "Imported components successfully."
    else
      render :new
    end
  end

private

  def import_params
    params.require(:component_import)
  end
end