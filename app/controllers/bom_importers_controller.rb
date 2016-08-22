class BomImportersController < BaseController
  def new
    @bom_importer = BomImporter.new
  end

  def create
    @bom_importer = BomImporter.new(import_params)
    if @bom_importer.save
      redirect_to boms_path, notice: "Imported boms successfully."
    else
      render :new
    end
  end

private

  def import_params
    params.require(:bom_importer)
  end
end