extends Node

const APP_ID : int = 6018

var bearer : String = ""
var schema = null

var SchemaScene = preload("res://addons/godot-enjin-api/scenes/schema.tscn")

	
#-------------------------------------------------------------------------------
func _ready():
	GraphQL.set_endpoint(true, "kovan.cloud.enjin.io/graphql", 0, "")
	call_deferred("_setup")


#-------------------------------------------------------------------------------
func _setup():
	var root = get_tree().root
	schema = SchemaScene.instance()
	root.add_child(schema)
	
	# Connects the queries and mutations' signals to methods.
	schema.login_query.connect("graphql_response", self, "_login_response")
	schema.get_app_secret_query.connect("graphql_response", self, "_get_app_secret_response")
	schema.retrieve_app_access_token_query.connect("graphql_response", self, "_retrieve_app_access_token_response")
	schema.create_player_mutation.connect("graphql_response", self, "_create_player_response")


#-------------------------------------------------------------------------------
func login(username : String, password : String):
	schema.login_query.run({
		"email": username,
		"password": password,
	})
	
	
#-------------------------------------------------------------------------------
func _login_response(result):
	#print(JSON.print(result, "\t"))
	
	var auth = result.data.EnjinOauth
	#print(auth)
	if auth != null:
		bearer = auth.accessTokens[0].accessToken
		schema.get_app_secret_query.set_bearer(bearer)
		schema.get_app_secret_query.run({
			"id": APP_ID,
		})
	

#-------------------------------------------------------------------------------
func _get_app_secret_response(result):
	var secret = result.data.EnjinApps[0].secret
	if secret != null:
		schema.retrieve_app_access_token_query.set_bearer(bearer)
		schema.retrieve_app_access_token_query.run({
			"appId": APP_ID,
			"appSecret": secret,
		})
		
		schema.create_player_mutation.set_bearer(bearer)
		schema.create_player_mutation.run({ "playerId": "Michael" })


#-------------------------------------------------------------------------------
func _retrieve_app_access_token_response(result):
	#var secret = result.data.EnjinApps[0].secret
	print(JSON.print(result, "\t"))


#-------------------------------------------------------------------------------
func _create_player_response(result):
	#var secret = result.data.EnjinApps[0].secret
	print(JSON.print(result, "\t"))


#-------------------------------------------------------------------------------
