# copy this file to your project!!!

module SwapselectHelper
	
	def swapselect( object_name, object, method, choices, params = {:size => 8 } ) 

		param_name = "#{method.to_s.singularize}_ids"
		size = params[:size] 
		selected = object.send param_name
		
		buff = "<script type='text/javascript'>"
		buff += "new SwapSelect('#{object_name.to_s}[#{param_name}][]', new Array("

		choices.each do |elem| 
			is_selected = selected.any? { |item| item == elem.last }
			
			buff += "new Array( '#{elem.last}', '#{elem.first}', #{is_selected} ),"
		end
		
		buff.slice!( buff.length - 1 )
		
		buff += "), #{size} );"
		buff += "</script>"
		
		return buff
	end	
	
end
