require 'mail'

module Unhackathon
	@@base_url = "http://localhost"
	private :base_url
end

Mail.defaults do |variable|
    delivery_method :smtp, address: 'smtp.gmail.com', port: 465, user_name: 'USER', password: 'PASSWORD', tls: true   
end
