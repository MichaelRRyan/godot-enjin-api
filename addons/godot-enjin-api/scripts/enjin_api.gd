extends Node

const APP_ID : int = 6018

var _root_ready = false
var _initialised = false
var _bearer : String = ""
var _schema = null
var _queued_queries = []

var _SchemaScene = preload("res://addons/godot-enjin-api/scenes/schema.tscn")


#-------------------------------------------------------------------------------
func connect_to_enjin() -> void:
	if not _root_ready:
		yield(get_tree().root, "ready")
		
	GraphQL.set_endpoint(true, "kovan.cloud.enjin.io/graphql", 0, "")
	_setup()


#-------------------------------------------------------------------------------
func login(username : String, password : String):
	_execute("login_query", {
		"email": username,
		"password": password,
	})


#-------------------------------------------------------------------------------
func _setup():
	var root = get_tree().root
	_schema = _SchemaScene.instance()
	root.add_child(_schema)
	
	# Connects the queries and mutations' signals to methods.
	_schema.login_query.connect("graphql_response", self, "_login_response")
	_schema.get_app_secret_query.connect("graphql_response", self, "_get_app_secret_response")
	_schema.retrieve_app_access_token_query.connect("graphql_response", self, "_retrieve_app_access_token_response")
	_schema.create_player_mutation.connect("graphql_response", self, "_create_player_response")
	
	_initialised = true
	
	# Runs any queued queries.
	if _queued_queries.size():
		for query in _queued_queries:
			_schema.get(query.query_name).run(query.args)


#-------------------------------------------------------------------------------
# Runs the query if initialised, queues it otherwise.
func _execute(query_name : String, args : Dictionary) -> void:
	if _initialised:
		_schema.get(query_name).run(args)
		
	else:
		_queued_queries.append({
			query_name = query_name,
			args = args,
		})


#-------------------------------------------------------------------------------
func _ready():
	get_tree().root.connect("ready", self, "_on_tree_ready")
	
	
#-------------------------------------------------------------------------------
func _on_tree_ready():
	_root_ready = true


#-------------------------------------------------------------------------------
func _login_response(result):
	print(JSON.print(result, "\t"))
	
	var auth = result.data.EnjinOauth
	#print(auth)
	if auth != null:
		_bearer = auth.accessTokens[0].accessToken
		_schema.get_app_secret_query.set_bearer(_bearer)
		_schema.get_app_secret_query.run({
			"id": APP_ID,
		})
	

#-------------------------------------------------------------------------------
func _get_app_secret_response(result):
	var secret = result.data.EnjinApps[0].secret
	if secret != null:
		_schema.retrieve_app_access_token_query.set_bearer(_bearer)
		_schema.retrieve_app_access_token_query.run({
			"appId": APP_ID,
			"appSecret": secret,
		})
		
		_schema.create_player_mutation.set_bearer(_bearer)
		_schema.create_player_mutation.run({ "playerId": "Michael" })


#-------------------------------------------------------------------------------
func _retrieve_app_access_token_response(result):
	#var secret = result.data.EnjinApps[0].secret
	print(JSON.print(result, "\t"))


#-------------------------------------------------------------------------------
func _create_player_response(result):
	#var secret = result.data.EnjinApps[0].secret
	print(JSON.print(result, "\t"))


#-------------------------------------------------------------------------------
