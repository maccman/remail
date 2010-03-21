require "activeresource"

module Remail
  def self.site=(site)
    Email.site = site
  end
  
  def self.app=(name)
    self.site = "http://#{name}.appspot.com"
  end
  
  def api_key=(key)
    Email.headers["Authorization"] = key
  end
  
  class Email < ActiveResource::Base
    self.timeout = 5
    
    cattr_accessor :headers
    @@headers = {}
    
    # Attributes:
    # * sender
    # * to
    # * cc
    # * bcc
    # * reply_to
    # * subject
    # * body
    # * html
    # 
    # sender, to, subject and 
    # body/html are required
    # 
    # The sender address must be the email address of a 
    # registered administrator for the application
    
    def from=(address)
      self.sender = address
    end
  end
end

begin
  require "actionmailer"
  
  class ActionMailer::Remail < ActionMailer::Base
    def perform_delivery_remail(mail)
      mail.destinations.each do |destination|
        REMail::Email.create :body => mail.encoded, :to => destination,
                             :from => mail.from.first
      end
    end
  end
  
rescue LoadError
end