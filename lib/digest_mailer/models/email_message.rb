module DigestMailer
  class EmailMessage < Struct.new(:recipient, :from_email, :message_params)
    cattr_accessor :mailer_method, :from_email, :to, :body, :intended_sent_at, :from

    def perform
      @message_params = message_params      
      @mailer_method = @message_params[:mailer_method] ? @message_params[:mailer_method] : 'generic_message'
      @from_email = from_email
      @from = nil #Fixme
      @to = recipient
      @body = "Fixme -- the body of this email message is not yet being set properly"
      send
    end

    # send the message to the queue for delivery
    def send
      @intended_sent_at = Time.now
      MailDispatcher.send(@mailer_method, self)
      MailLogger.log(self)
    end

  end
end
