class ComponentsController < BaseController
  def index
    @components = Component.all
  end
end