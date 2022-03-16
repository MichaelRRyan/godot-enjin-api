extends Node

#-------------------------------------------------------------------------------
onready var login_query = GraphQL.query("Login", {
		"email": "String!",
		"password": "String!",
	}, GQLQuery.new("EnjinOauth").set_args({ 
		"email": "email",
		"password": "password",
	}).set_props([
		"id",
		"name",
		"accessTokens",
	]))


#-------------------------------------------------------------------------------
onready var get_app_secret_query = GraphQL.query("GetAppSecret", {
		"id": "Int!",
	}, GQLQuery.new("EnjinApps").set_args({ 
		"id": "id",
	}).set_props([
		"secret",
	]))
	

#-------------------------------------------------------------------------------
onready var retrieve_app_access_token_query = GraphQL.query("RetrieveAppAccessToken", {
		"appId": "Int!",
		"appSecret": "String!",
	}, GQLQuery.new("AuthApp").set_args({ 
		"appId": "id",
		"appSecret": "secret",
	}).set_props([
		"accessToken",
		"expiresIn",
	]))
	

#-------------------------------------------------------------------------------
onready var create_player_mutation = GraphQL.mutation("CreatePlayer", {
		"playerId": "String!",
	}, GQLQuery.new("CreatePlayer").set_args({ 
		"playerId": "id",
	}).set_props([
		"accessToken",
	]))
	

#-------------------------------------------------------------------------------
func _ready():
	add_child(login_query)
	add_child(get_app_secret_query)
	add_child(retrieve_app_access_token_query)
	add_child(create_player_mutation)


#-------------------------------------------------------------------------------
