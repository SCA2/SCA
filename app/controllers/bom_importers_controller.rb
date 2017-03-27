class BomImportersController < BaseController
  def new
    @bom_importer = BomImporter.new
  end

  def create
    @bom_importer = BomImporter.new(import_params)
    if @bom_importer.save
      redirect_to boms_path, notice: "Imported BOM successfully."
    else
      render :new
    end
  rescue
    redirect_to new_bom_importer_path, alert: "Please choose a file."
  end

  def update_option
    filter = OptionFilter.new(params[:product_id])
    render json: filter.options.to_json
  end

private

  def import_params
    params.require(:bom_importer)
  end
end