require './emails'
require 'csv'

if ARGV.length < 1 then
  puts "Usage: ruby accept.rb csv_file"
end

CSV.foreach(ARGV[0]) do |row|
  id = row[1].to_i
  signup = Signup.find(id)
  emailer = Unhackathon::SignupEmailer.new(signup)
  reject_or_accept = row[0]
  begin
    if reject_or_accept == 'accept' then
      puts "sending acceptance to: #{signup.email}"
      emailer.send_acceptance
    elsif reject_or_accept == 'reject'
      puts "sending rejection to: #{signup.email}"
      emailer.send_rejection
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