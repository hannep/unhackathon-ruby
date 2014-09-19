require 'erubis'

require './app'

ActiveRecord::Base.logger.level = 1
module Unhackathon
  class SignupEmailer
    def initialize(signup)
      @signup = signup
      @email = signup.email
      @name = signup.name
      @token = signup.validation_token
      @id = signup.id
      @location = signup.location || ""
    end

    def base_url
      Unhackathon::Application.settings.email_base_url
    end

    def token_url(path)
      "#{base_url}/#{path}?token=#{@token}&id=#{@id}"
    end

    def confirm_url(transit)
      "#{token_url('confirm')}&transit=#{transit}"
    end

    def cancel_url
      "#{token_url('cancel')}"
    end

    def double_confirm_url
      "#{token_url('double_confirm')}"
    end

    def location_html()
      unless /^[a-z_0-9, ]+$/i.match(@location) then
        raise "Locations can only be alphanumeric + underscores"
      end
      render_body("locations/#{@location}")
    end

    def location_text()
      unless /^[a-z_0-9, ]+$/i.match(@location) then
        raise "Locations can only be alphanumeric + underscores"
      end
      render_location_text("locations/#{@location}")
    end

    def render_location_text(file_name)
      template_text = File.read(File.join(File.dirname(__FILE__), "emails/#{file_name}.erb"))
      template_text = template_text.gsub("<p>", "").gsub("</p>", "").gsub("<br>", "")
      giant_double_confirm_button = lambda {
        double_confirm_url
      }
      Erubis::Eruby.new(template_text).result(binding())
    end

    def giant_double_confirm_button
      render_body("giant_double_confirm_button")
    end

    def render_body(file_name)
      template_text = File.read(File.join(File.dirname(__FILE__), "emails/#{file_name}.erb"))
      Erubis::Eruby.new(template_text).result(binding())
    end

    def send_email(email_from:, mail_subject:, html_template: nil, text_template: nil)
      if html_template then
        html_body = render_body(html_template)
      end
      if text_template then
        text_body = render_body(text_template)
      end
      to_email = @email
      mail = Mail.deliver do
        to      to_email
        from    email_from
        subject mail_subject

        if text_template then
          text_part do
            body text_body
          end
        end

        if html_template then
          html_part do
            content_type 'text/html; charset=UTF-8'
            body html_body
          end
        end
      end
    end

    def assert_valid_signup
      if @signup.rejected_or_accepted then
        raise "Cannot accept/reject someone twice"
      end
    end

    def send_acceptance()
      assert_valid_signup      
      send_email mail_subject: "ACTION REQUIRED: Your Unhackathon application has been accepted.",
                 html_template: "acceptance",
                 text_template: "acceptance_text",
                 email_from: 'Hanne @ Unhackathon <hanne@unhackathon.org>'
      @signup.accepted!
      @signup.save
    end

    def send_rejection
      assert_valid_signup
      send_email mail_subject: "Your Unhackathon Application Decision",
                 html_template: "rejection",
                 text_template: "rejection_text",
                 email_from: 'Team @ Unhackathon <team@unhackathon.org>'
      @signup.rejected!
      @signup.save
    end

    def send_highschool_rejection
      assert_valid_signup
      send_email mail_subject: "Your Unhackathon Application Decision",
                 html_template: "highschool_rejection",
                 text_template: "highschool_rejection_text",
                 email_from: 'Team @ Unhackathon <team@unhackathon.org>'
      @signup.rejected!
      @signup.is_highschool = true
      @signup.save
    end

    def resend_accepted
      if !@signup.accepted? then
        raise "Cannot resend acceptance for non accepted signup"
      end
      puts "Sending for #{@signup.email}"
      send_email mail_subject: "You're in! Your Unhackathon application has been accepted.",
                 html_template: "acceptance",
                 text_template: "acceptance_text",
                 email_from: 'Hanne @ Unhackathon <hanne@unhackathon.org>'
    end

    def send_double_confirmed
      if !@signup.confirmed? then
        raise "Cannot send double confirmation for non-confirmed signup"
      end
      if @location == "" or @location == nil then
        puts "Skipping #{@signup.email}: fCannot send double confirmation if there is no location"
      elsif @signup.is_location_sent
        puts "Skipping #{@signup.email}"
      else
        puts "Sending for #{@signup.email}"
        send_email mail_subject: "News From Unhackathon",
                   html_template: "double_confirm",
                   text_template: "double_confirm_text",
                   email_from: 'Team @ Unhackathon <team@unhackathon.org>'
        @signup.is_location_sent = true
        @signup.save!
      end
    end


    def send_transit_all
      if @signup.cancelled? then
        raise "Cannot send double confirmation for non-confirmed signup"
      end
    
      puts "Sending for #{@signup.email}"
      send_email mail_subject: "Reminder - Your Unhackathon Travel",
                 text_template: "transitall_text",
                 email_from: 'Team @ Unhackathon <team@unhackathon.org>'
    end

    def send_leftover_double
      if !@signup.confirmed? then
        raise "Cannot send double confirmation for non-confirmed signup"
      end
      if @signup.is_double_confirmed then
        raise "Cannot send leftover double to someone who is double confirmed"
      end
    
      if @signup.is_leftover_double_sent
        puts "Skipping #{@signup.email}"
      else
        puts "Sending for #{@signup.email}"
        send_email mail_subject: "Action required: Important update from Unhackathon.",
                   html_template: "leftover_double",
                   email_from: 'Team @ Unhackathon <team@unhackathon.org>'
        @signup.is_leftover_double_sent = true
        @signup.save!
      end
    end
  end

  def self.send_transit_all
    signups = Signup.where.not(status: "cancelled")
    signups.each do |signup|
      SignupEmailer.new(signup).send_transit_all
    end
  end

  def self.resend_accepted
    signups = Signup.where(status: "accepted")
    signups.each do |signup|
      SignupEmailer.new(signup).resend_accepted
    end
  end

  def self.send_double_confirmed
    signups = Signup.where(status: "confirmed")
    signups.each do |signup|
      SignupEmailer.new(signup).send_double_confirmed
    end
  end

  def self.send_leftover_double
    signups = Signup.where(status: "confirmed", is_double_confirmed: false)
    signups.each do |signup|
      SignupEmailer.new(signup).send_leftover_double
    end
  end
end



