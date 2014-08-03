require File.expand_path('app', File.dirname(__FILE__))
require 'sinatra/activerecord/rake'

task :start do
    conf = File.expand_path('config.ru', File.dirname(__FILE__))
    exec("thin -e development -R #{conf} --debug start")
end
