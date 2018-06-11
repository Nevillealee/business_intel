require_relative 'business_intel'
require 'sinatra/activerecord/rake'
require 'resque/tasks'

namespace :business_intel do 

desc "push file to aws s3 bucket"
task :push_test_file do |t|
    FamBusinessIntel::FamAWS.new.push_to_s3

end

desc "push all subscriptions to file"
task :push_all_subs do |t|
    FamBusinessIntel::FamAWS.new.push_all_subscriptions
end

desc "push all line items to file"
task :push_all_line_items do |t|
    FamBusinessIntel::FamAWS.new.push_sub_line_items
end

desc "push skip_reasons to file"
task :push_skip_reasons do |t|
    FamBusinessIntel::FamAWS.new.push_skip_reasons
end

    
end