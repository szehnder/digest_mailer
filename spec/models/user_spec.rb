require 'spec_helper'

describe User do
  
  describe "create" do
    before(:all) do
      @user = Factory.create(:user)
      @daily = Factory.create(:daily_digest_user)
      @weekly = Factory.create(:weekly_digest_user)
      @admin = Factory.create(:admin)
      @cd = Factory.create(:creative_director_user)
      @invalid = Factory.create(:invalid_user)
    end
    
    it { @user.should_not be_nil }
    it { @user.id.should > 0 }
    
    it { @daily.should_not be_nil }
    it { @daily.id.should > 0 }
    
    it { @weekly.should_not be_nil }
    it { @weekly.id.should > 0 }
    
    it { @admin.should_not be_nil }
    it { @admin.id.should > 0 }

    it { @cd.should_not be_nil }
    it { @cd.id.should > 0 }
    
    #it { @invalid.should be_nil }
    #it { @invalid.id.should be_nil }
    

  end
end
    
      
