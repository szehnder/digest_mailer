require 'spec_helper'

describe EmailLog do
    it { should belong_to :email_message }
    it { should validate_presence_of :recipient_id }
    it { should validate_presence_of :intended_sent_at }
    it { should validate_presence_of :mailer_method }

  context "can create" do
    before do
      @log = Factory.create(:email_log)
    end

    it { @log.should_not be_nil }
    it { @log.id.should_not be_nil }
  end
end