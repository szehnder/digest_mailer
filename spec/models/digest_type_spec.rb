require 'spec_helper'

describe DigestType do
  it { should have_many :email_digests }
  it { should validate_presence_of :name }
  pending { should validate_uniqueness_of :name }

  context "can create" do
    before do
      @daily = Factory.create(:daily)
      @weekly = Factory.create(:weekly)
    end

    it { @daily.should_not be_nil }
    it { @daily.id.should_not be_nil }

    it { @weekly.should_not be_nil }
    it { @weekly.id.should_not be_nil }
  end
end