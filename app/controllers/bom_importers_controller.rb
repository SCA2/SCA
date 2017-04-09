class BomImportersController < BaseController
  def new
    @bom_importer = BomImporter.new
  end

  def create
    @bom_importer = BomImporter.new(import_params)

    unless @bom_importer.bom.present?
      redirect_to new_bom_importer_path, alert: "That BOM doesn't exist. Do you need to create it?"
    end
    
    unless @bom_importer.file.present?
      redirect_to new_bom_importer_path, alert: "Can't open that file."
    end

    if @bom_importer.save
      redirect_to boms_path, notice: "Imported BOM successfully."
    else
      render :new
    end
  rescue
    redirect_to new_bom_importer_path, alert: "Can't save the BOM."
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