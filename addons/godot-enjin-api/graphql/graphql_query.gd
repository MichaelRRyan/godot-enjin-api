class_name GraphQLQuery

var _name : String = ""
var _arguments : Dictionary = {}
var _properties : Array = []


#-------------------------------------------------------------------------------
func _init(name : String) -> void:
	_name = name


#-------------------------------------------------------------------------------
func set_args(args : Dictionary) -> GraphQLQuery:
	_arguments = args
	return self

	
#-------------------------------------------------------------------------------
func set_props(props : Array) -> GraphQLQuery:
	_properties = props
	return self


#-------------------------------------------------------------------------------
func to_string() -> String:
	var output = _name
	
	# Converts the arguments to a string.
	if not _arguments.empty():
		output += "("
		var sep = ""
		for key in _arguments.keys():
			output += sep + key + ": $" + _arguments[key]
			sep = ", "
		output += ")"
	
	# Converts the properties to a string.
	if not _properties.empty():
		output += " {\n"
		for prop in _properties:
			if prop is GraphQLQuery:
				output += prop + "\n"
			else:
				output += prop + "\n"
		output += "}"
	
	return output


#-------------------------------------------------------------------------------
