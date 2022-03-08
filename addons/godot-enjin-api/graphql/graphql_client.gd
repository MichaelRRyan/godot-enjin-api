extends Node

var _endpoint : String = "" setget set_endpoint
var _authorization : String = "" setget set_bearer


#-------------------------------------------------------------------------------
func set_endpoint(value : String) -> void:
	_endpoint = value


#-------------------------------------------------------------------------------
func set_bearer(value : String) -> void:
	_authorization = "Authorization: Bearer " + value


#-------------------------------------------------------------------------------
