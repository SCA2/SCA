class ComponentsController < BaseController

  before_action :signed_in_admin

  helper_method :component

  def new
    @component = Component.new
  end

  def index
    @components = Component.all
  end

  def edit
  end

  def create
    @component = Component.new(component_params)
    if @component.save
      flash[:success] = "Component #{@component.mfr_part_number} created"
      redirect_to components_path
    else
      render 'new'
    end
  end

  def update
    if component.update(component_params)
      redirect_to components_path, notice: "Component #{@component.mfr_part_number} updated"
    else
      render 'edit'
    end
  end

  def destroy
    component_id = component.id
    component.destroy
    redirect_to components_path, notice: "Component #{component_id} deleted"
  end

  def component
    @component ||= Component.find(params[:id])
  end

private

  def component_params
    params.require(:component).permit(Component.permitted_attributes)
  end
end