require './emails'

Unhackathon::send_leftover_double

Mail::TestMailer.deliveries.each { |mail|
  puts "to: #{mail.to}"
  puts "subject: #{mail.subject}"
  puts mail.body
  puts mail.to_s
}