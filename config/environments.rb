#These Settings Establish the Proper Database Connection for Heroku Postgres
#The environment variable DATABASE_URL should be in the following format:
# => postgres://{user}:{password}@{host}:{port}/path
#This is automatically configured on Heroku, you only need to worry if you also
#want to run your app locally
configure :production do
	set :database, {adapter: "sqlite3", database: "db/database.sqlite3"}
end

configure :development do 
	set :database, {adapter: "sqlite3", database: "db/database.sqlite3"}

end

configure do 
	#This can have passwords, so we need a separate file next to us.
	#If we were more awesome we might use an environment variable
	require_relative "./mail"
end

