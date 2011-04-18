module DigestMailer
  class PendingMessage < Struct.new(:recipient, :message, :intended_sent_at, :mailer_method)
    attr_accessor :recipient, :message, :mailer_method, :intended_sent_at
    
      def perform
        @recipient = recipient
        @mailer_method = mailer_method
        @message = message
        @intended_sent_at = Time.now
        send
      end

      # send the message to the queue for delivery
      def send_message
        MailDispatcher.send(@mailer_method, @recipient, self)
        MailLogger.log(self)
      end
  end
end