require 'aws-sdk-s3'
require 'dotenv'
Dotenv.load
require 'csv'
require 'active_record'
require "sinatra/activerecord"
require_relative 'models/model'



module FamBusinessIntel
    class FamAWS

    def initialize
        
        @aws_key = ENV['AWS_KEY']
        @aws_secret_key = ENV['AWS_SECRET_KEY']

        

    end

    def push_to_s3

        Aws.config.update({
            credentials: Aws::Credentials.new(@aws_key, @aws_secret_key)
         })
        s3 = Aws::S3::Resource.new(region: 'us-east-1')
        file = 'test.csv'
        bucket = 'fambrands-business-intelligence'
        name = File.basename(file)
        
        path = 'exports/MYTEST_funky.csv'
        #s3.bucket('fambrands-business-intelligence').object(path).upload_file('test.csv')

        obj = s3.bucket(bucket).object(path)
        obj.upload_file(name)


    end

    def push_all_subscriptions
        
        #Headers for CSV
        column_header = ["subscription_id", "address_id", "customer_id", "created_at", "updated_at", "next_charge_scheduled_at", "cancelled_at", "product_title", "price", "quantity", "status", "shopify_product_id", "shopify_variant_id", "sku", "order_interval_unit", "charge_interval_unit", "order_day_of_month", "order_day_of_week", "raw_line_item_properties", "synced_at", "expire_after_specific_charges"]
        #delete old file
        File.delete('subscriptions.csv') if File.exist?('subscriptions.csv')
        CSV.open('subscriptions.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
            column_header = nil

        mysubs = Subscription.all
        mysubs.each do |sub|
            puts sub.inspect
            #Construct the CSV string
            sub_id = sub.subscription_id
            address_id = sub.address_id
            customer_id = sub.customer_id
            created_at = sub.created_at
            updated_at = sub.updated_at
            next_charge_scheduled_at = sub.next_charge_scheduled_at
            cancelled_at = sub.cancelled_at
            product_title = sub.product_title
            price = sub.price
            quantity = sub.quantity
            status = sub.status
            shopify_product_id = sub.shopify_product_id
            shopify_variant_id = sub.shopify_variant_id
            sku = sub.sku
            order_interval_unit = sub.order_interval_unit
            order_interval_frequency = sub.order_interval_frequency
            charge_interval_frequency = sub.charge_interval_frequency
            order_day_of_month = sub.order_day_of_month
            order_day_of_week = sub.order_day_of_week
            raw_line_item_properties = sub.raw_line_item_properties
            synced_at = sub.synced_at
            expire_after_specific_number_charges = sub.expire_after_specific_number_charges
            csv_data_out = [sub_id, address_id, customer_id, created_at, updated_at, next_charge_scheduled_at, cancelled_at, product_title, price, quantity, status, shopify_product_id, shopify_variant_id, sku, order_interval_unit, order_interval_frequency, order_day_of_month, order_day_of_week, raw_line_item_properties, synced_at, expire_after_specific_number_charges ]
            hdr << csv_data_out

        end
        
        #end of csv part
        end

        #AWS Stuff
        Aws.config.update({
            credentials: Aws::Credentials.new(@aws_key, @aws_secret_key)
         })
        s3 = Aws::S3::Resource.new(region: 'us-east-1')
        
        path = 'exports/etl_subscriptions.csv'
        #Alternate method
        #s3.bucket('fambrands-business-intelligence').object(path).upload_file('subscriptions.csv')

        file = 'subscriptions.csv'
        bucket = 'fambrands-business-intelligence'
        name = File.basename(file)
        
        obj = s3.bucket(bucket).object(path)
        obj.upload_file(name)


    end

    def push_sub_line_items
        #Headers for CSV
        column_header = ["subscription_id", "name", "value"]
        #delete old file
        File.delete('sub_line_items.csv') if File.exist?('sub_line_items.csv')
        CSV.open('sub_line_items.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
            column_header = nil

        my_sub_line_items = SubLineItem.all
        my_sub_line_items.each do |myline|
            puts myline.inspect
            my_name = myline.name
            my_value = myline.value
            csv_data_out = [my_name, my_value ]
            hdr << csv_data_out

        end

        #end of csv hdr
        end

        #push to S3
        Aws.config.update({
            credentials: Aws::Credentials.new(@aws_key, @aws_secret_key)
         })
        s3 = Aws::S3::Resource.new(region: 'us-east-1')
        
        path = 'exports/etl_sub_line_items.csv'
        #Alternate method
        #s3.bucket('fambrands-business-intelligence').object(path).upload_file('subscriptions.csv')

        file = 'sub_line_items.csv'
        bucket = 'fambrands-business-intelligence'
        name = File.basename(file)
        
        obj = s3.bucket(bucket).object(path)
        obj.upload_file(name)

    end

    def push_skip_reasons

        #Headers for CSV
        column_header = ["customer_id", "shopify_customer_id", "subscription_id", "charge_id", "reason", "skipped_to", "skip_status", "created_at", "updated_at"]
        #delete old file
        File.delete('skip_reasons.csv') if File.exist?('skip_reasons.csv')
        CSV.open('skip_reasons.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
            column_header = nil

        my_skip_reasons = SkipReason.all
        my_skip_reasons.each do |myreason|
            puts myreason.inspect
            customer_id = myreason.customer_id
            shopify_customer_id = myreason.shopify_customer_id
            charge_id = myreason.charge_id
            reason = myreason.reason
            skipped_to = myreason.skipped_to
            skip_status = myreason.skip_status
            created_at = myreason.created_at
            updated_at = myreason.updated_at
            csv_data_out = [customer_id, shopify_customer_id, charge_id, reason, skipped_to, skip_status, created_at, updated_at ]
            hdr << csv_data_out

        end
        #end of CSV hdr
        end

        #push to S3
        Aws.config.update({
            credentials: Aws::Credentials.new(@aws_key, @aws_secret_key)
         })
        s3 = Aws::S3::Resource.new(region: 'us-east-1')
        
        path = 'exports/etl_skip_reasons.csv'
        #Alternate method
        #s3.bucket('fambrands-business-intelligence').object(path).upload_file('subscriptions.csv')

        file = 'skip_reasons.csv'
        bucket = 'fambrands-business-intelligence'
        name = File.basename(file)
        
        obj = s3.bucket(bucket).object(path)
        obj.upload_file(name)


    end


    end
end