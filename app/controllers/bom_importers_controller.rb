class BomImportersController < BaseController
  def new
    @bom_importer = BomImporter.new
  end

  def create
    @bom_importer = BomImporter.new(import_params)

    unless @bom_importer.bom.present?
      flash.now[:alert] = "That BOM doesn't exist. Do you need to create it?"
      render :new
    end
    
    unless @bom_importer.file.present?
      flash.now[:alert] = "Can't open that file."
      render :new
    end

    if @bom_importer.save
      redirect_to boms_path, notice: "Imported BOM successfully."
    else
      render :new
    end
  rescue
    flash.now[:alert] = "Can't save the BOM."
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