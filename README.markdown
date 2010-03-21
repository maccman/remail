Remail is RESTful email for Rails.

Forget configuring SMTP servers and queues, just use Remail. 
Remail uses Google App Engine to send and receive emails RESTfully.

# Features
* POST emails to your Remail App Engine in order to send them
* Remail POSTS received emails back to a configurable URL

# Setup
* Configure and deploy the [Remail App Engine](http://github.com/maccman/remail-engine)
* Install the Remail gem (sudo gem install remail)
* Configure ActionMailer and Remail:
    Remail.app = "remail-yourapp"
    Remail.api_key = "changeme"
    ActionMailer::Base.delivery_method = :remail