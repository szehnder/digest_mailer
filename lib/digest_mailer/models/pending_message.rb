require_relative 'non_user_recipient'
module DigestMailer
  class PendingMessage
    attr_accessor :recipient, :message, :intended_sent_at, :mailer_method
    
    def initialize(recipient, message, intended_sent_at=Time.now, mailer_method='generic_message')
      self.recipient = recipient
      self.message = message
      self.intended_sent_at = intended_sent_at
      self.mailer_method = mailer_method
    end
    
      # send the message to the queue for delivery
      def send_message
        Rails.logger.info("RECIPIENT :::> #{recipient}") if recipient.kind_of?(Fixnum)
        recipient_email = (recipient.kind_of?(Hash)) ? recipient[:email] : recipient.email
        m = MailDispatcher.generic_message(recipient_email, self.message)
        m.deliver if Rails.env!='test'
      end
  end
end