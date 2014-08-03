require "sinatra"
require 'sinatra/activerecord'
require 'thin'
require 'securerandom'
require './config/environments' #database configuration
require './models/model'        #Model class
require 'mail'

get "/" do
	erb :index
end

post "/create_signup" do
	params.inspect
  s = Signup.new(params)
  s.is_validated = false
  s.validation_token = SecureRandom.urlsafe_base64(32)
  s.save if s

  url = "#{request.base_url}/validate?id=#{s.id}&token=#{s.validation_token}"
  mail = Mail.new do
    from    'team@unhackathon.org'
    to      'johnsdaniels@gmail.com'
    subject 'This is a test email'
    body    "GO here to confirm #{url}"
  end

  mail.deliver!

  "Success"
end

get "/validate" do 
  token = params[:token]
  id = params[:id].to_i
  signup = Signup.find(id)
  if signup.validation_token == token then
    signup.is_validated = true
    signup.save
    "Success"
  else
    "Failure"
  end
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