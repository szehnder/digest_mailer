module DigestMailer
  class EmailMessage < Struct.new(:recipient, :from_email, :subject, :body, :message_params)
    cattr_accessor :mailer_method, :from_email, :to, :body, :from, :subject, :intended_sent_at

    def perform
      @message_params = message_params      
      @mailer_method = @message_params[:mailer_method] ? @message_params[:mailer_method] : 'generic_message'
      @from_email = from_email
      @from = nil #Fixme
      @subject = subject
      @body = body
      @to = recipient
      @intended_sent_at = Time.now
      send
    end

    # send the message to the queue for delivery
    def send
      MailDispatcher.send(@mailer_method, self)
      MailLogger.log(self)
    end

  end
end
