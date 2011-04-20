#because of logging and the way the mailer expects an email param, a NonUser struct is created for all 'other_recipients'
#module DigestMailer
  class NonUserRecipient
    attr_accessor :email
    
    def initialize(email)
      @email = email
    end
    
  end
#end