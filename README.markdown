Remail is RESTful email for Rails.

Forget configuring SMTP servers and queues, just use Remail. 
Remail uses Google App Engine to send and receive emails RESTfully.

Remail only support Rails 3.

## Features
* POST emails to your Remail App Engine in order to send them
* Remail POSTS received emails back to a configurable URL

## Setup
* Configure and deploy the [Remail App Engine](http://github.com/maccman/remail-engine)
* Install the Remail gem (sudo gem install remail)

## Sending email
  Configure ActionMailer and Remail:
  
``config.action_mailer.delivery_method = :remail
  config.action_mailer.remail_settings = {
    :app_name => "remail-appname",
    :api_key  => "changeme"
  }``
  
## Receiving email
  * Configure the callback URL in your Remail App Engine.
  * Create a email controller, that looks a bit like this (remember to configure the routes):
  
  ``  
  class EmailsController < ApplicationController
    skip_before_filter :verify_authenticity_token

    def create
      UserMailer.receive(params[:email][:raw])
      head :success
    end
  end
  ``
  
  The API key is also passed through as an Authorization header,
  you should definitely validate that.
  
  You should also add :email to the filter_parameters configuration, you 
  don't want your logs being clogged up with emails.