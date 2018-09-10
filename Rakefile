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

  desc "push all charges to file"
  task :push_all_charges do |t|
      FamBusinessIntel::FamAWS.new.push_all_charges
  end

  desc "push billing addresses to file"
  task :push_billing_addresses do |t|
      FamBusinessIntel::FamAWS.new.push_billing_addresses
  end

  desc "push client details to file"
  task :push_client_details do |t|
      FamBusinessIntel::FamAWS.new.push_client_details
  end

  desc "push fixed line items to file"
  task :push_fixed_line_items do |t|
      FamBusinessIntel::FamAWS.new.push_fixed_line_items
  end

  desc "push variable line items"
  task :push_variable_line_items do |t|
      FamBusinessIntel::FamAWS.new.push_variable_line_items
  end

  desc "push shipping addresses"
  task :push_shipping_addresses do |t|
      FamBusinessIntel::FamAWS.new.push_shipping_addresses
  end

  desc "push shipping lines"
  task :push_shipping_lines do |t|
      FamBusinessIntel::FamAWS.new.push_shipping_lines
  end

  desc "push recharge customers"
  task :push_recharge_customers do |t|
      FamBusinessIntel::FamAWS.new.push_recharge_customers
  end

  desc "push marika customers"
  task :push_marika_customers do |t|
    FamBusinessIntel::FamAWS.new.push_marika_cust
  end

  desc "push_marika_orders"
  task :push_marika_orders do |t|
    FamBusinessIntel::FamAWS.new.push_marika_orders
  end

end
