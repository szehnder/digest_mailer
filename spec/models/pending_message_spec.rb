require 'spec_helper'

describe DigestMailer::PendingMessage do
  before(:all) do
    @msg = DigestMailer::PendingMessage.new(Factory.create(:user), Factory.create(:plain_email), Time.now, 'generic_mailer')
  end
  
  it { @msg.recipient.should_not be_nil }
  it { @msg.message.should_not be_nil }
  it { @msg.intended_sent_at.should_not be_nil }
  it { @msg.mailer_method.should_not be_nil } 
end

  