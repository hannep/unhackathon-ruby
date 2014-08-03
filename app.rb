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
  #We have to stop the part of the username after the plus, so we don't
  # get signups from 'different' emails that are actually the same.
  email = params[:email].gsub(/\+.*@/, "@")
  old_signup = Signup.find_by email: email
  if old_signup != nil and old_signup.is_validated then
    return "Failure: email already exists"
  end
  s = Signup.new(params)
  s.email = email
  s.is_validated = false
  s.validation_token = SecureRandom.urlsafe_base64(32)
  s.save if s

  url = "#{request.base_url}/validate?id=#{s.id}&token=#{s.validation_token}"
  email_text = erb :email, locals: { :url=> url }, layout: false

  mail = Mail.new do
    from    'team@unhackathon.org'
    to      email
    subject 'Thanks for your interest in unhackathon!'
    body    email_text
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
    erb :confirmed
  else
    "Failure"
  end
end

get "/signups" do 
	@signups = Signup.all
	erb :signups
end

get "/questions" do
  @questions = Question.all
  erb :questions
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