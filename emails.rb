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

    def render_body(file_name)
      template_text = File.read(File.join(File.dirname(__FILE__), "emails/#{file_name}.erb"))
      Erubis::Eruby.new(template_text).result(binding())
    end

    def send_email(mail_subject:, html_template:, text_template:)
      html_body = render_body(html_template)
      text_body = render_body(text_template)
      to_email = @email
      mail = Mail.deliver do
        to      to_email
        from    'Hanne @ Unhackathon <hanne@unhackathon.org>'
        subject mail_subject

        text_part do
          body text_body
        end

        html_part do
          content_type 'text/html; charset=UTF-8'
          body html_body
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
      send_email mail_subject: "You're in! Your Unhackathon application has been accepted.",
                 html_template: "acceptance",
                 text_template: "acceptance_text"
      @signup.accepted!
      @signup.save
    end

    def send_rejection
      assert_valid_signup
      send_email mail_subject: "Your application has been rejected",
                 html_template: "acceptance",
                 text_template: "acceptance_text"
      @signup.rejected!
      @signup.save
    end
  end
end

