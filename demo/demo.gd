extends Node


#-------------------------------------------------------------------------------
func _ready():
	Enjin.connect_to_enjin()
	Enjin.login(Secret.username, Secret.password)


#-------------------------------------------------------------------------------
