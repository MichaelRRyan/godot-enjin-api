extends Node


#-------------------------------------------------------------------------------
func _ready():
	call_deferred("_test")
	

#-------------------------------------------------------------------------------
func _test():
	# Runs the login query.
	Enjin.schema.login_query.run({
		"email": Secret.username,
		"password": Secret.password,
	})


#-------------------------------------------------------------------------------
