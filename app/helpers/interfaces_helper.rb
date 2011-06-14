module InterfacesHelper

  def error_div_for(model)
      %{<div id="errors_for_#{model.class.name.underscore}"></div>}
  end

end
