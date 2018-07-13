module Customers

  def push_recharge_customers
    puts "push recharge customers task started"
    column_header = [
      "customer_id",
      "customer_hash",
      "shopify_customer_id",
      "email",
      "created_at",
      "updated_at",
      "first_name",
      "last_name",
      "billing_address1",
      "billing_address2",
      "billing_zip",
      "billing_city",
      "billing_company",
      "billing_province",
      "billing_country",
      "billing_phone",
      "processor_type",
      "status",
      "synced_at"
    ]
    File.delete('recharge_customers.csv') if File.exist?('recharge_customers.csv')
    recharge_custs = RechargeCustomer.all
    CSV.open('recharge_customers.csv','a+', :write_headers=> true, :headers => column_header) do |hdr|
    column_header = nil
    recharge_custs.each do |cust|
      #Construct the CSV string
      customer_id = cust.id
      customer_hash = cust.customer_hash
      shopify_customer_id = cust.shopify_customer_id
      email = cust.email
      created_at = cust.created_at
      updated_at = cust.updated_at
      first_name = cust.first_name
      last_name = cust.last_name
      billing_address1 = cust.billing_address1
      billing_address2 = cust.billing_address2
      billing_zip = cust.billing_zip
      billing_city = cust.billing_city
      billing_company = cust.billing_company
      billing_province = cust.billing_province
      billing_country = cust.billing_country
      billing_phone = cust.billing_phone
      processor_type = cust.processor_type
      status = cust.status
      synced_at = cust.synced_at

      csv_data_out = [
        customer_id,
        customer_hash,
        shopify_customer_id,
        email,
        created_at,
        updated_at,
        first_name,
        last_name,
        billing_address1,
        billing_address2,
        billing_zip,
        billing_city,
        billing_company,
        billing_province,
        billing_country,
        billing_phone,
        processor_type,
        status,
        synced_at
      ]
        hdr << csv_data_out
      end
    end
    #AWS Stuff
    aws_upload('recharge_customers')
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
