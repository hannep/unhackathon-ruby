require "sinatra"
require 'sinatra/activerecord'
require 'thin'
require './config/environments' #database configuration
require './models/model'        #Model class

get "/" do
	erb :index
end

post "/create_signup" do
	params.inspect
  s = Signup.new(params)
  s.save if s
  "Success"
end

get "/signups" do 
	@signups = Signup.all
	erb :signups, :layout => :layout2
end

get "/questions" do
  @questions = Question.all
  erb :questions, :layout => :layout2
end

after do
  # Close the connection after the request is done so that we don't
  # deplete the ActiveRecord connection pool.
  ActiveRecord::Base.connection.close
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end