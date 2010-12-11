require "active_resource"

module Remail
  def site=(site)
    Email.site = site
  end
  module_function :site=
  
  def app_id=(name)
    self.site = "http://#{name}.appspot.com"
  end
  module_function :app_id=
  
  def api_key=(key)
    Email.headers["Authorization"] = key
  end
  module_function :api_key=
  
  class Email < ActiveResource::Base
    self.timeout = 5
    self.format  = :json
    self.include_root_in_json = false
    
    cattr_accessor :headers
    @@headers = {}
    
    schema do
      string :sender, :to, :cc, :bcc,
             :reply_to, :subject,
             :body, :html
    end
    
    validates_presence_of :sender, :to, :subject
    validates_presence_of :body, :unless => :html?

    # The sender address must be the email address of a 
    # registered administrator for the application    
    def from=(address)
      self.sender = address
    end
  end
  
  class ActionMailer
    def initialize(settings)
      settings.each {|key, value| 
        Remail.send("#{key}=", value) 
      }
    end
        
    def deliver!(mail)
      remail = Remail::Email.new
      
      %w{to from cc bcc reply_to}.each {|attr|
        value = mail.header[attr]
        next unless value
        remail.send("#{attr}=", value.to_s)
      }      
      
      remail.subject  = mail.subject
      
      text_body   = mail.text_part ? mail.text_part.body : mail.body
      html_body   = mail.html_part && mail.html_part.body
      remail.body = text_body.encoded if text_body
      remail.html = html_body.encoded if html_body
      
      remail.save!
    end
  end
end

begin
  require "action_mailer"
  ActionMailer::Base.add_delivery_method(:remail, Remail::ActionMailer)
rescue LoadError
end