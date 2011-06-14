module AssetsHelper

  def error_div_for(model)
      %{<div id="errors_for_#{model.class.name.underscore}"></div>}
  end

  def fields_for_asset(type,asset,&block)
    prefix = asset.new_record? ? 'new_' : ''
    fields_for("#{type}[#{prefix}asset_attributes]", asset, &block)
  end 
end
