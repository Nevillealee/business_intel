# Business Intelligence Reporting 

 An Automated tool for tranferring Shopify api data into an AWS s3 bucket for sql server consumption/analytics 

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. 

### Prerequisites

ruby 2.5.1<br/>
bundler<br/>
redis<br/>
aws s3 bucket + account<br/>
shopify store + private app w/fullaccess
```
https://rvm.io/rvm/install
https://bundler.io/
*For Ubuntu systems: 
  https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-18-04
*For Mac Homebrew: 
  $ brew install redis
  (to start redis using default conf file):
  $ redis-server /usr/local/etc/redis.conf
https://aws.amazon.com/s3/
https://www.shopify.com/signup
```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```
## Deployment

Add additional notes about how to deploy this on a live system

## Built With

* [Sinatra](http://sinatrarb.com/) - The web framework  mimicked 
* [bundler](https://bundler.io/) - Dependency Management
* [AWS SDK for Ruby](https://aws.amazon.com/sdk-for-ruby/) - Used to connect to Amazon S3

## Authors

* **Neville Lee** - *Initial work* - [Nevillealee](https://github.com/nevillealee)
