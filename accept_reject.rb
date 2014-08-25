require './emails'
require 'csv'

if ARGV.length < 1 then
  puts "Usage: ruby accept.rb csv_file"
end

CSV.foreach(ARGV[0]) do |row|
  id = row[1].to_i
  signup = Signup.find(id)
  emailer = Unhackathon::SignupEmailer.new(signup)
  action_to_perform = row[0]
  begin
    if action_to_perform == 'accept' then
      puts "sending acceptance to: #{signup.email}"
      emailer.send_acceptance
    elsif action_to_perform == 'reject'
      puts "sending rejection to: #{signup.email}"
      emailer.send_rejection
    elsif action_to_perform == 'highschool'
      puts "sending highschool rejection to: #{signup.email}"
      emailer.send_highschool_rejection
    else
      puts "skipping: #{signup.email}"
    end
  rescue => e
    puts "ERROR: #{e.message}"
  end
end

Mail::TestMailer.deliveries.each { |mail|
  puts "to: #{mail.to}"
  puts "subject: #{mail.subject}"
  puts mail.body
  puts mail.to_s
}