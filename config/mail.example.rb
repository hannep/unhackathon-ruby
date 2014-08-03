Mail.defaults do |variable|
    delivery_method :smtp, address: 'smtp.gmail.com', port: 465, user_name: 'USER', password: 'PASSWORD', tls: true   
end