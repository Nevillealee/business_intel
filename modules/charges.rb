module Charges

  def push_all_charges

    column_header = [
      "address_id",
      "billing_address",
      "client_details",
      "created_at",
      "customer_hash",
      "customer_id",
      "first_name",
      "charge_id",
      "last_name",
      "line_items",
      "note",
      "note_attributes",
      "processed_at",
      "scheduled_at",
      "shipments_count",
      "shipping_address",
      "shopify_order_id",
      "status",
      "sub_total",
      "sub_total_price",
      "tags",
      "tax_lines",
      "total_discounts",
      "total_line_items_price",
      "total_tax",
      "total_weight",
      "total_price",
      "updated_at",
      "discount_codes",
      "synced_at",
      "raw_line_items",
      "raw_shipping_lines",
      "browser_ip"
    ]

    File.delete('charges.csv') if File.exist?('charges.csv')
    mycharges = Charge.all
    CSV.open('charges.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
    column_header = nil
    mycharges.each do |chrg|
      #Construct the CSV string
      address_id = chrg.address_id
      billing_address = chrg.billing_address.to_json
      client_details = chrg.client_details.to_json
      created_at = chrg.created_at
      customer_hash = chrg.customer_hash
      customer_id = chrg.customer_id
      first_name = chrg.first_name
      charge_id = chrg.charge_id
      last_name = chrg.last_name
      line_items = chrg.line_items.to_json
      note = chrg.note
      note_attributes = chrg.note_attributes
      processed_at = chrg.processed_at
      scheduled_at = chrg.scheduled_at
      shipments_count = chrg.shipments_count
      shipping_address = chrg.shipping_address.to_json
      shopify_order_id = chrg.shopify_order_id
      status = chrg.status
      sub_total = chrg.sub_total
      sub_total_price = chrg.sub_total_price
      tags = chrg.tags
      tax_lines = chrg.tax_lines
      total_discounts = chrg.total_discounts
      total_line_items_price = chrg.total_line_items_price
      total_tax = chrg.total_tax
      total_weight = chrg.total_weight
      total_price = chrg.total_price
      updated_at = chrg.updated_at
      discount_codes = chrg.discount_codes.to_json
      synced_at = chrg.synced_at
      raw_line_items = chrg.raw_line_items
      raw_shipping_lines = chrg.raw_shipping_lines
      browser_ip = chrg.browser_ip

      csv_data_out = [
        address_id,
        billing_address,
        client_details,
        created_at,
        customer_hash,
        customer_id,
        first_name,
        charge_id,
        last_name,
        line_items,
        note,
        note_attributes,
        processed_at,
        scheduled_at,
        shipments_count,
        shipping_address,
        shopify_order_id,
        status,
        sub_total,
        sub_total_price,
        tags,
        tax_lines,
        total_discounts,
        total_line_items_price,
        total_tax,
        total_weight,
        total_price,
        updated_at,
        discount_codes,
        synced_at,
        raw_line_items,
        raw_shipping_lines,
        browser_ip
      ]
        hdr << csv_data_out
      end
    end
    #AWS Stuff
    aws_upload('charges')
  end

  def push_billing_addresses
    column_header = [
      "address1",
      "address2",
      "city",
      "company",
      "country",
      "first_name",
      "last_name",
      "phone",
      "province",
      "zip",
      "charge_id"
    ]

    File.delete('billing_addresses.csv') if File.exist?('billing_addresses.csv')
    my_addresses = Charge.all
    CSV.open('billing_addresses.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
    column_header = nil

    my_addresses.each do |addy|
      #Construct the CSV string
      address1 = addy.billing_address['address1']
      address2 = addy.billing_address['address2']
      city = addy.billing_address['city']
      company = addy.billing_address['company']
      country = addy.billing_address['country']
      first_name = addy.billing_address['first_name']
      last_name = addy.billing_address['last_name']
      phone = addy.billing_address['phone']
      province = addy.billing_address['province']
      zip = addy.billing_address['zip']
      charge_id = addy.charge_id

      csv_data_out = [
        address1,
        address2,
        city,
        company,
        country,
        first_name,
        last_name,
        phone,
        province,
        zip,
        charge_id
      ]
        hdr << csv_data_out
      end
    end
    #AWS Stuff
    aws_upload('billing_addresses')
  end # push_billing_addresses END

  def push_client_details
    column_header = ["charge_id", "browser_ip", "user_agent"]

    File.delete('client_details.csv') if File.exist?('client_details.csv')
    charges = Charge.all
    CSV.open('client_details.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
    column_header = nil

    charges.each do |charge|
      puts "charge_id: #{charge.charge_id}, browser_ip: #{charge.client_details['browser_ip']}, user_agent: #{charge.client_details['user_agent']}"
      # puts charge.charge_id.inspect
      #Construct the CSV string
      charge_id = charge.charge_id
      browser_ip = charge.client_details['browser_ip']
      user_agent = charge.client_details['user_agent']

      csv_data_out = [charge_id, browser_ip, user_agent]
        hdr << csv_data_out
      end
    end
    #AWS Stuff
    aws_upload('client_details')
  end

  def push_fixed_line_items
    column_header = [
      "charge_id",
      "grams",
      "price",
      "quantity",
      "shopify_product_id",
      "shopify_variant_id",
      "sku",
      "subscription_id",
      "title",
      "variant_title",
      "vendor"
    ]
    File.delete('fixed_line_items.csv') if File.exist?('fixed_line_items.csv')
    line_items = ChargeFixedLineItems.all
    CSV.open('fixed_line_items.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
    column_header = nil

    line_items.each do |l_item|
      puts l_item.inspect
      #Construct the CSV string
      charge_id = l_item.charge_id
      grams = l_item.grams
      price = l_item.price
      quantity = l_item.quantity
      shopify_product_id = l_item.shopify_product_id
      shopify_variant_id = l_item.shopify_variant_id
      sku = l_item.sku
      subscription_id = l_item.subscription_id
      title = l_item.title
      variant_title = l_item.variant_title
      vendor = l_item.vendor

      csv_data_out = [
        charge_id,
        grams,
        price,
        quantity,
        shopify_product_id,
        shopify_variant_id,
        sku,
        subscription_id,
        title,
        variant_title,
        vendor
      ]
        hdr << csv_data_out
      end
    end
    #AWS Stuff
    aws_upload('fixed_line_items')
  end

  def push_variable_line_items
    column_header = ["charge_id", "name", "value"]
    File.delete('variable_line_items.csv') if File.exist?('variable_line_items.csv')
    sql = "select * from charge_variable_line_items;"
    line_items_array = ActiveRecord::Base.connection.execute(sql)

    CSV.open('variable_line_items.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
    column_header = nil
    line_items_array.each do |l_item|
      puts l_item.inspect
      #Construct the CSV string
      charge_id = l_item['charge_id']
      name = l_item['name']
      value = l_item['value']

      csv_data_out = [charge_id, name, value]
        hdr << csv_data_out
      end
    end
    # AWS Stuff
    aws_upload('variable_line_items')
  end

  def push_shipping_addresses
    column_header = [
      "charge_id",
      "address1",
      "address2",
      "city",
      "company",
      "country",
      "first_name",
      "last_name",
      "phone",
      "province",
      "zip"
    ]
    File.delete('shipping_addresses.csv') if File.exist?('shipping_addresses.csv')
    sql = "select * from charges_shipping_address;"
    shipping_addresses = ActiveRecord::Base.connection.execute(sql)

    CSV.open('shipping_addresses.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
    column_header = nil
    shipping_addresses.each do |shipping_addy|
      puts shipping_addy.inspect
      #Construct the CSV string
      charge_id = shipping_addy['charge_id']
      address1 = shipping_addy['address1']
      address2 = shipping_addy['address2']
      city = shipping_addy['city']
      company = shipping_addy['company']
      country = shipping_addy['country']
      first_name = shipping_addy['first_name']
      last_name = shipping_addy['last_name']
      phone = shipping_addy['phone']
      province = shipping_addy['province']
      zip = shipping_addy['zip']

      csv_data_out = [
        charge_id,
        address1,
        address2,
        city,
        company,
        country,
        first_name,
        last_name,
        phone,
        province,
        zip
      ]
        hdr << csv_data_out
      end
    end
    # AWS Stuff
    aws_upload('shipping_addresses')
  end

  def push_shipping_lines
    column_header = [
      "charge_id",
      "code",
      "price",
      "source",
      "title",
      "tax_lines",
      "carrier_identifier",
      "request_fulfillment_service_id"
    ]
    File.delete('shipping_lines.csv') if File.exist?('shipping_lines.csv')
    shipping_lines = ChargeShippingLine.all

    CSV.open('shipping_lines.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
    column_header = nil
    shipping_lines.each do |shipping_line|
      puts shipping_line.inspect
      #Construct the CSV string
      charge_id = shipping_line.charge_id
      code = shipping_line.code
      price = shipping_line.price
      source = shipping_line.source
      title = shipping_line.title
      tax_lines = shipping_line.tax_lines
      carrier_identifier = shipping_line.carrier_identifier
      request_fulfillment_service_id = shipping_line.request_fulfillment_service_id

      csv_data_out = [
        charge_id,
        code,
        price,
        source,
        title,
        tax_lines,
        carrier_identifier,
        request_fulfillment_service_id
      ]
        hdr << csv_data_out
      end
    end
    # AWS Stuff
    aws_upload('shipping_lines')
  end

 # pushes given table name to fambrands-business-intelligence aws bucket
 # as table_name.csv to path: exports/etl_#{table_name}.csv
  def aws_upload(table_name)
    Aws.config.update({
    credentials: Aws::Credentials.new(@aws_key, @aws_secret_key)
    })
    s3 = Aws::S3::Resource.new(region: 'us-east-1')

    path = "exports/etl_#{table_name}.csv"
    #Alternate method
    #s3.bucket('fambrands-business-intelligence').object(path).upload_file('subscriptions.csv')

    file = "#{table_name}.csv"
    bucket = 'fambrands-business-intelligence'
    name = File.basename(file)
    obj = s3.bucket(bucket).object(path)
    obj.upload_file(name)
    puts "upload to aws complete"
  end


end
