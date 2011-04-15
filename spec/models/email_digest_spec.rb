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

    it { @daily.digest_type.should_not be_nil }
    it { @daily.embargoed_until.should_not be_nil }

  end

  context "should be able to set it's frequency based on a user preference" do
    describe "daily digest" do
      before do
        @digest = Factory.create(:email_digest, :user => Factory(:daily_digest_user))
      end

      it { @digest.should_not be_nil }
      it { @digest.id.should_not be_nil }
      it { @digest.digest_type.should_not be_nil }
      it { @digest.digest_type.name.should == "daily" }
    end

    describe "weekly digest" do
      before do
        @digest = Factory.create(:email_digest, :user => Factory(:weekly_digest_user))
      end

      it { @digest.should_not be_nil }
      it { @digest.id.should_not be_nil }
      it { @digest.digest_type.should_not be_nil }
      it { @digest.digest_type.name.should == "weekly" }
    end
  end
end
