class_name GraphQLQuery

var _name : String = ""
var _arguments : Dictionary = {}
var _fields : Array = []


#-------------------------------------------------------------------------------
func _init(name : String) -> void:
	_name = name


#-------------------------------------------------------------------------------
func set_args(args : Dictionary) -> GraphQLQuery:
	_arguments = args
	return self

	
#-------------------------------------------------------------------------------
func set_fields(fields : Array) -> GraphQLQuery:
	_fields = fields
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
	if not _fields.empty():
		output += " {\n"
		for field in _fields:
			if field is GraphQLQuery:
				output += field + "\n"
			else:
				output += field + "\n"
		output += "}"
	
	return output


#-------------------------------------------------------------------------------
