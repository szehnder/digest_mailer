require 'spec_helper'
require 'digest_mailer/mail_logger'
require 'digest_mailer/models/pending_message'

describe DigestMailer::MailLogger do
  describe "log" do
    before do
      @to = Factory.create(:user)
      @cd = Factory.create(:creative_director_user)
      @from = Factory.create(:admin)
      @email1 = Factory.create(:plain_email)
      @email2 = Factory.create(:html_email)
      @message1 = DigestMailer::PendingMessage.new(@to, @email1, Time.now, 'generic_mailer')
      @message2 = DigestMailer::PendingMessage.new(@cd, @email2, Time.now, 'generic_mailer')
    end
    
    it { @to.should_not be_nil }
    it { @email1.should_not be_nil }
    it { @email2.should_not be_nil }
    it { @message1.recipient.should_not be_nil }
    it { @message1.recipient.id.should > 0 }
    it { @message1.message.should_not be_nil }
    it { @message1.message.id.should > 0 }
    it { @message1.intended_sent_at.should_not be_nil }
    it { @message1.mailer_method.should_not be_nil }
    
    
     describe "should persist 1 rows in the EmailLog tbl" do
          before do
            DigestMailer::MailLogger.log(@to.email, @email1, 'generic_message', Time.now)
          end
          
          it { EmailLog.count.should == 1 }
      end
    
    describe "should persist 2 rows in the EmailLog tbl" do
        before do
          DigestMailer::MailLogger.log(@to.email, @email1, 'generic_message', Time.now)
          DigestMailer::MailLogger.log(@to.email, @email2, 'generic_message', Time.now)
        end
        
        it { EmailLog.count.should == 2 }
    end
    
    
  end
end
