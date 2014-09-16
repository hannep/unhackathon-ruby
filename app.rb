require 'sinatra/activerecord'
require 'thin'
require 'securerandom'
require 'sinatra/base'
require './config/environments' #database configuration
require './models/model'        #Model class
require 'mail'
require 'erubis'


module Unhackathon
  class Application < Sinatra::Application
    set :app_file, __FILE__
    set :erb, :escape_html => true
    get "/" do
      s = Signup.new
    	erb :index
    end

    get "/mentors" do
      s = Signup.new
      erb :mentors
    end

    post "/create_signup" do
      #We have to stop the part of the username after the plus, so we don't
      # get signups from 'different' emails that are actually the same.
      email = params[:email].gsub(/\+.*@/, "@")
      old_signup = Signup.find_by email: email
      if old_signup != nil then
        if old_signup.is_validated then
          return [400, "Email already exists"]
        end
        s = old_signup
      else
        s = Signup.new(params)
      end
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

    post "/mentor_signup" do
      signup = MentorSignup.new(params)
      signup.save
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

    post "/tshirt" do
      token = params[:token]
      id = params[:id].to_i
      shirt_size = params[:shirt_size]
      signup = Signup.find(id)
      if signup.validation_token == token  && signup.can_confirm_or_cancel then
        signup.shirt_size = shirt_size
        signup.save
        "Success"
      else
        [400, "Invalid Token"]
      end
    end

    get "/tshirt" do 
      token = params[:token]
      id = params[:id].to_i
      transit = params[:transit]
      signup = Signup.find(id)
      if signup.validation_token == token && signup.can_confirm_or_cancel then
        signup.transit = transit
        signup.confirmed!
        signup.save
        erb :tshirt, locals: {:token => token, :id => id}
      else
        "Failure"
      end
    end

    get "/confirm" do 
      token = params[:token]
      id = params[:id].to_i
      transit = params[:transit]
      signup = Signup.find(id)
      if signup.validation_token == token && signup.can_confirm_or_cancel then
        if signup.shirt_size == '' || signup.shirt_size == nil then
          return redirect to("/tshirt?token=#{token}&id=#{id}&transit=#{transit}")
        end
        signup.transit = transit
        signup.confirmed!
        signup.save
        erb :confirm_going
      else
        "Failure"
      end
    end

    get "/double_confirm" do 
      token = params[:token]
      id = params[:id].to_i
      transit = params[:transit]
      signup = Signup.find(id)
      if signup.validation_token == token && signup.confirmed? then
        signup.is_double_confirmed = true
        signup.save
        erb :double_confirmed
      else
        "Failure"
      end
    end

    get "/cancel" do
      token = params[:token]
      id = params[:id].to_i
      signup = Signup.find(id)
      if signup.validation_token == token && signup.can_confirm_or_cancel then
        signup.cancelled!
        signup.save
        erb :cancelled
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

    run! if app_file == $0
  end
end
