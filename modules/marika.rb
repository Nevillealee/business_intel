module Marika
  CUSTOMER_ARRAY = []
  ORDER_ARRAY = []
  def pull_marika_cust
    my_url = "https://#{ENV['ACTIVE_API_KEY']}:#{ENV['ACTIVE_API_PW']}@#{ENV['ACTIVE_SHOP']}.myshopify.com/admin"
    ShopifyAPI::Base.site = my_url
    customer_count = ShopifyAPI::Customer.count
    nb_pages = (customer_count / 250.0).ceil

    1.upto(nb_pages) do |page|
      my_endpoint = "https://#{ENV['ACTIVE_API_KEY']}:#{ENV['ACTIVE_API_PW']}@#{ENV['ACTIVE_SHOP']}.myshopify.com/admin/customers.json?limit=250&page=#{page}"
      shopify_api_throttle
      @parsed_response = HTTParty.get(my_endpoint)
      CUSTOMER_ARRAY.push(@parsed_response['customers'])
      p "customers set #{page}/#{nb_pages} loaded"
      sleep 3
    end
    CUSTOMER_ARRAY.flatten!
    p 'customers initialized'
    return CUSTOMER_ARRAY
  end

  def push_marika_cust
    puts "push marika customers task started"
    column_header = [
      "customer_id",
      "accepts_marketing",
      "addresses",
      "default_address",
      "email",
      "first_name",
      "last_name",
      "last_order_id",
      "metafield",
      "multipass_identifier",
      "note",
      "orders_count",
      "phone",
      "state",
      "tags",
      "tax_exempt",
      "total_spent",
      "verified_email",
      "created_at",
      "updated_at"
    ]
    File.delete('marika_customers.csv') if File.exist?('marika_customers.csv')
    marika_custs = pull_marika_cust
    CSV.open('marika_customers.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
    column_header = nil
    marika_custs.each do |cust|
      #Construct the CSV string
      customer_id = cust["id"]
      accepts_marketing = cust["accepts_marketing"]
      addresses = cust["addresses"].to_json
      default_address = cust["default_address"].to_json
      email = cust["email"]
      first_name = cust["first_name"]
      last_name = cust["last_name"]
      last_order_id = cust["last_order_id"]
      metafield = cust["metafield"]
      multipass_identifier = cust["multipass_identifier"]
      note = cust["note"]
      orders_count = cust["orders_count"]
      phone = cust["phone"]
      state = cust["state"]
      tags = cust["tags"]
      tax_exempt = cust["tax_exempt"]
      total_spent = cust["total_spent"]
      verified_email = cust["verified_email"]
      created_at = cust["created_at"]
      updated_at = cust["updated_at"]

      csv_data_out = [
        customer_id,
        accepts_marketing,
        addresses,
        default_address,
        email,
        first_name,
        last_name,
        last_order_id,
        metafield,
        multipass_identifier,
        note,
        orders_count,
        phone,
        state,
        tags,
        tax_exempt,
        total_spent,
        verified_email,
        created_at,
        updated_at
      ]
        hdr << csv_data_out
      end
    end
    #AWS Stuff
    aws_upload('marika_customers')
  end

  def pull_marika_orders
    my_url = "https://#{ENV['ACTIVE_API_KEY']}:#{ENV['ACTIVE_API_PW']}@#{ENV['ACTIVE_SHOP']}.myshopify.com/admin"
    ShopifyAPI::Base.site = my_url
    my_min = "2017-01-01"
    my_max = "2018-09-05"
    puts "my_min = #{my_min}, my_max = #{my_max}"
    order_count = ShopifyAPI::Order.count( created_at_min: my_min, created_at_max: my_max, status: 'any')
    puts "order count: #{order_count}"
    nb_pages = (order_count / 250.0).ceil

    begin
      1.upto(nb_pages) do |page|
        orders = ShopifyAPI::Order.find(:all, params: {limit: 250, created_at_min: my_min, created_at_max: my_max, status: 'any', page: page})
        orders.each do |my_order|
          puts my_order.id
          ORDER_ARRAY.push(my_order)
        end
        p "orders set #{page}/#{nb_pages} loaded, sleeping 8.."
         sleep 8
      end
    rescue StandardError => e
      puts e
    end
    p 'orders initialized'
    p "order array size: #{ORDER_ARRAY.size}"
    return ORDER_ARRAY
  end

  def push_marika_orders
    puts "push marika orders task started"
    column_header = [
      "order_id",
      "app_id",
      "billing_address",
      "browser_ip",
      "buyer_accepts_marketing",
      "cancel_reason",
      "cancelled_at",
      "cart_token",
      "client_details",
      "closed_at",
      "created_at",
      "currency",
      "customer",
      "customer_locale",
      "discount_applications",
      "discount_codes",
      "email",
      "financial_status",
      "fulfillments",
      "fulfillment_status",
      "landing_site",
      "location_id",
      "name",
      "note",
      "note_attributes",
      "number",
      "order_number",
      "payment_gateway_names",
      "phone",
      "processed_at",
      "processing_method",
      "referring_site",
      "refunds",
      "shipping_address",
      "shipping_lines",
      "source_name",
      "subtotal_price",
      "tags",
      "tax_lines",
      "taxes_included",
      "token",
      "total_discounts",
      "total_line_items_price",
      "total_price",
      "total_tax",
      "total_weight",
      "updated_at",
      "user_id",
      "order_status_url",
      "line_items"
    ]
    File.delete('marika_orders.csv') if File.exist?('marika_orders.csv')
    marika_orders = pull_marika_orders
    puts marika_orders.size
    CSV.open('marika_orders.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
    column_header = nil
    marika_orders.each do |order|
      #Construct the CSV string
      begin
      order_id = order.id
      app_id = order.app_id
      billing_address = order.try(:billing_address).to_json
      browser_ip = order.try(:browser_ip)
      buyer_accepts_marketing = order.try(:buyer_accepts_marketing)
      cancel_reason = order.try(:cancel_reason)
      cancelled_at = order.try(:cancelled_at)
      cart_token = order.try(:cart_token)
      client_details = order.try(:client_details).to_json
      closed_at = order.try(:closed_at)
      created_at = order.try(:created_at)
      currency = order.try(:currency)
      customer = order.try(:customer).to_json
      customer_locale = order.try(:customer_locale)
      discount_applications = order.try(:discount_applications).to_json
      discount_codes = order.try(:discount_codes).to_json
      email = order.try(:email)
      financial_status = order.try(:financial_status)
      fulfillments = order.try(:fulfillments).to_json
      fulfillment_status = order.try(:fulfillment_status)
      landing_site = order.try(:landing_site)
      location_id = order.try(:location_id)
      name = order.try(:name)
      note = order.try(:note)
      note_attributes = order.try(:note_attributes).to_json
      number = order.try(:number)
      order_number = order.try(:order_number)
      payment_gateway_names = order.try(:payment_gateway_names).join(",")
      phone = order.try(:phone)
      processed_at = order.try(:processed_at)
      processing_method = order.try(:processing_method)
      referring_site = order.try(:referring_site)
      refunds = order.try(:refunds).to_json
      shipping_address = order.try(:shipping_address)
      shipping_lines = order.try(:shipping_lines).to_json
      source_name = order.try(:source_name)
      subtotal_price = order.try(:subtotal_price)
      tags = order.try(:tags)
      tax_lines = order.try(:tax_lines).to_json
      taxes_included = order.try(:taxes_included)
      token = order.try(:token)
      total_discounts = order.try(:total_discounts)
      total_line_items_price = order.try(:total_line_items_price)
      total_price = order.try(:total_price)
      total_tax = order.try(:total_tax)
      total_weight = order.try(:total_weight)
      updated_at = order.try(:updated_at)
      user_id = order.try(:user_id)
      order_status_url = order.try(:order_status_url)
      line_items = order.try(:line_items).to_json
    rescue StandardError => e
      puts e
      next
    end

      csv_data_out = [
        order_id,
        app_id,
        billing_address,
        browser_ip,
        buyer_accepts_marketing,
        cancel_reason,
        cancelled_at,
        cart_token,
        client_details,
        closed_at,
        created_at,
        currency,
        customer,
        customer_locale,
        discount_applications,
        discount_codes,
        email,
        financial_status,
        fulfillments,
        fulfillment_status,
        landing_site,
        location_id,
        name,
        note,
        note_attributes,
        number,
        order_number,
        payment_gateway_names,
        phone,
        processed_at,
        processing_method,
        referring_site,
        refunds,
        shipping_address,
        shipping_lines,
        source_name,
        subtotal_price,
        tags,
        tax_lines,
        taxes_included,
        token,
        total_discounts,
        total_line_items_price,
        total_price,
        total_tax,
        total_weight,
        updated_at,
        user_id,
        order_status_url,
        line_items
      ]
        hdr << csv_data_out
      end
    end
    #AWS Stuff
    aws_upload('marika_orders')
  end

  def aws_upload(table_name)
   Aws.config.update({
   credentials: Aws::Credentials.new(@aws_key, @aws_secret_key)
   })
   s3 = Aws::S3::Resource.new(region: 'us-east-1')
   path = "exports/etl_#{table_name}.csv"
   file = "#{table_name}.csv"
   bucket = 'fambrands-business-intelligence'
   name = File.basename(file)
   obj = s3.bucket(bucket).object(path)
   obj.upload_file(name)
   puts "upload to aws complete"
  end

  def shopify_api_throttle
   ShopifyAPI::Base.site =
     "https://#{ENV['ACTIVE_API_KEY']}:#{ENV['ACTIVE_API_PW']}@#{ENV['ACTIVE_SHOP']}.myshopify.com/admin"
     return if ShopifyAPI.credit_left > 5
     puts "credit limit reached, sleeping 10..."
   sleep 10
  end
end
