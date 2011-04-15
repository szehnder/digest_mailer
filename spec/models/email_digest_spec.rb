require 'spec_helper'

describe EmailDigest do
  #it { should validate_presence_of :digest_type }
  it { should have_and_belong_to_many :email_messages }

  context "can create both daily and weekly digests" do
    before do
      @daily = Factory.create(:daily_digest)
      @weekly = Factory.create(:weekly_digest)
    end

    it { @daily.id.should_not be_nil }
    it { @weekly.id.should_not be_nil }
    it { DigestType.count.should == 2 }
    
    pending "intended_sent_at should not be null"
    pending "append_message should work properly"

  end
  
  context "should be able to set it's frequency based on a user preference" do
    before do
      @user = Factory.create(:email_digest, :user => Factory(:daily_digest_user))
    end

    it { @user.should_not be_nil }
    it { @user.id.should_not be_nil }
  end
end
