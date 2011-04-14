require 'spec_helper'
require 'digest_mailer/mail_logger'
require 'digest_mailer/models/pending_message'

describe DigestMailer::MailLogger do
  describe "log" do
    before do
      @to = Factory(:user)
      @cd = Factory(:creative_director_user)
      @from = Factory(:admin)
      @message = DigestMailer::PendingMessage.new(@to, Factory(:plain_email))
      @message2 = DigestMailer::PendingMessage.new(@cd, Factory(:html_email))
    end
       
    it "should persist a new row in the EmailLog tbl" do
        lambda {
           @log = DigestMailer::MailLogger.log(@message)
         }.should change { EmailLog.count }.by(1)
    end
    
    it "should persist 2 rows in the EmailLog tbl" do
        lambda {
          DigestMailer::MailLogger.log(@message)
          DigestMailer::MailLogger.log(@message2)
         }.should change { EmailLog.count }.by(2)
    end
    
    
  end
end
