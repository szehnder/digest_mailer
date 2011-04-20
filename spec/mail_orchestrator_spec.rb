require 'spec_helper'

describe DigestMailer::MailOrchestrator do
  include DelayedJobSpecHelper
  
  before(:all) do 
    @standard_role = Factory.create(:standard_role)
    @cd_role = Factory.create(:cd_role)
    @admin_role = Factory.create(:admin_role)

    @d1 = Factory.create(:user, :discipline_id => 1, :roles => [@standard_role], :receive_frequency => 'immediately')          
    @d2 = Factory.create(:user, :discipline_id => 2, :roles => [@standard_role], :receive_frequency => 'immediately')          
    @d3 = Factory.create(:szehnder1, :discipline_id => 3, :roles => [@standard_role], :receive_frequency => 'daily')     
    @d4 = Factory.create(:user, :discipline_id => 4, :roles => [@standard_role], :receive_frequency => 'weekly')     
    @d4_2 = Factory.create(:user, :discipline_id => 4, :roles => [@standard_role], :receive_frequency => 'weekly')
    @d5 = Factory.create(:user, :discipline_id => 5, :roles => [@standard_role], :receive_frequency => 'daily')

    @cd = Factory.create(:creative_director_user, :discipline_id => 1, :roles => [@cd_role], :receive_frequency => 'immediately')

    @project = Factory.create(:project)

    Factory.create(:membership, :memberable => @project, :user => @d3) 
    Factory.create(:cd_membership, :memberable => @project, :user => @cd)

    @all_users = [@d1, @d2, @d3, @d4, @d4_2, @d5]
  end

  describe "should_skip_user_preferences_by_scope" do
    it "should not skip for some" do
      DigestMailer::MailOrchestrator.should_skip_user_preferences_by_scope('by_user_id').should be_false
      DigestMailer::MailOrchestrator.should_skip_user_preferences_by_scope('by_all_users').should be_false
    end
 
    it "should skip/ignore user preferences for other cases" do
      DigestMailer::MailOrchestrator.should_skip_user_preferences_by_scope('by_project_id').should be_true
      DigestMailer::MailOrchestrator.should_skip_user_preferences_by_scope('by_discipline_id').should be_true
      DigestMailer::MailOrchestrator.should_skip_user_preferences_by_scope('by_invite_user_id').should be_true
      DigestMailer::MailOrchestrator.should_skip_user_preferences_by_scope('by_all_users_with_idea').should be_true
      DigestMailer::MailOrchestrator.should_skip_user_preferences_by_scope('by_all_users_with_idea_on_a_project').should be_true
    end
  end

  describe "recipients_by_scope" do 
    before(:all) do
      @message_params = {:other_recipients => ['szehnder@victorsandspoils.com'], :body => 'This message has a body.'}
      @idea = Factory.create(:idea, :user => @d1, :project => @project)
      @idea2 = Factory.create(:idea, :user => @d2, :project => @project)
    end
 
    it "should find one recipient for by_user_id" do
      params = @message_params.clone
      params[:id] = User.last.id
      params[:scope] = 'by_user_id'
      DigestMailer::MailOrchestrator.recipients_by_scope(params).count.should == 1
    end

    it "should properly identify recipients by_project_id" do
      params = @message_params.clone
      params[:id] = @project.id
      params[:scope] = 'by_project_id'
      DigestMailer::MailOrchestrator.recipients_by_scope(params).count.should == 2
    end

    it "should properly identify recipients by_user_array" do
      params = @message_params.clone
      params[:user_recipients] = User.all(:limit => 3)
      params[:scope] = 'by_user_array'
      DigestMailer::MailOrchestrator.recipients_by_scope(params).count.should == 3
    end

    it "should properly identify recipients by_all_users" do
      params = @message_params.clone
      params[:scope] = 'by_all_users'
      DigestMailer::MailOrchestrator.recipients_by_scope(params).count.should == 7
    end

    it "should properly identify recipients by_discipline_id" do
      params = @message_params.clone
      params[:id] = 4
      params[:scope] = 'by_discipline_id'
      DigestMailer::MailOrchestrator.recipients_by_scope(params).count.should == 2
    end

    it "should properly identify recipients by_invite_user_id" do
      params = @message_params.clone
      params[:id] = 2
      params[:scope] = 'by_invite_user_id'
      DigestMailer::MailOrchestrator.recipients_by_scope(params).count.should == 1
    end

    it "should properly identify recipients by_all_users_with_idea" do
      params = @message_params.clone
      params[:scope] = 'by_all_users_with_idea'
      DigestMailer::MailOrchestrator.recipients_by_scope(params).count.should == 2
    end

  end

  describe "user_can_receive_emails" do
    it "should recognize that a user can receive mail" do
      DigestMailer::MailOrchestrator.user_can_receive_emails(@d1).should be_true
    end

    it "should recognize a user that cannot receive mail" do
      DigestMailer::MailOrchestrator.user_can_receive_emails(Factory(:invalid_user)).should be_false
    end
  end

  describe "user_prefers_email_digests" do
    it "should recognize a digest user" do
      DigestMailer::MailOrchestrator.user_prefers_email_digests(@d4).should be_true
      DigestMailer::MailOrchestrator.user_prefers_email_digests(@d5).should be_true
    end

    it "should recognize an immediate user" do
      DigestMailer::MailOrchestrator.user_prefers_email_digests(@d1).should be_false
      DigestMailer::MailOrchestrator.user_prefers_email_digests(@d2).should be_false
    end
  end

  describe "should separate the digest users from the ones who prefer immediate emails" do
    before do
      @obj = DigestMailer::MailOrchestrator.separate_immediate_from_digest_recipients(@all_users)
    end

    it "should separate the users by email preference" do
      @obj[:digest].count.should == 4
      @obj[:immediate].count.should == 2
    end
  end

  context "API Testing" do
    
    context "by_user_id" do
      describe "regular user" do
        before do
          DigestMailer::MailOrchestrator.prepare({:scope => "by_user_id", :id => @cd.id, :body => 'This is the body of a message 1.', :subject => 'This is the subject line 1'}, ['test@mail.com'])
        end
        it { EmailDigest.count.should == 0 }
        it { EmailMessage.count.should == 1 }
        it { Delayed::Job.count.should == 2 }
      end
      describe "daily digest user" do
        before do
          DigestMailer::MailOrchestrator.prepare({:scope => "by_user_id", :id => @d3.id, :body => 'This is the body of a message 1.', :subject => 'This is the subject line 1'})
          DigestMailer::MailOrchestrator.prepare({:scope => "by_user_id", :id => @d3.id, :body => 'This is the body of a message 2.', :subject => 'This is the subject line 2'})
          DigestMailer::MailOrchestrator.prepare({:scope => "by_user_id", :id => @d3.id, :body => 'This is the body of a message 3.', :subject => 'This is the subject line 3'})
        end
        it { EmailDigest.count.should == 1 }
        it { EmailMessage.count.should == 3 }
        it { Delayed::Job.count.should == 1
          work_off 
        }
      end
      describe "weekly digest user" do
        before do
          DigestMailer::MailOrchestrator.prepare({:scope => "by_user_id", :id => @d4.id, :body => 'This is the body of a message 1.', :subject => 'This is the subject line 1'})
        end
        it { EmailDigest.count.should == 1 }
        it { EmailMessage.count.should == 1 }
        it { 
          Delayed::Job.count.should == 1
          #work_off
        }
      end
    end
    
    describe "by_user_array" do
        before do
          DigestMailer::MailOrchestrator.prepare({:scope => "by_user_array", :user_recipients => @all_users, :body => 'This is the body of a message 1.', :subject => 'This is the subject line 1'})
          DigestMailer::MailOrchestrator.prepare({:scope => "by_user_array", :user_recipients => @all_users, :body => 'This is the body of a message 2.', :subject => 'This is the subject line 2'})
        end
        it { @all_users.length.should == 6 }
        it { User.count.should == 7 }
        it { EmailDigest.count.should == 4 }
        it { EmailMessage.count.should == 2 }
        it { Delayed::Job.count.should == 8 }
    end
    
    describe "by_invite_user_id" do
        before do
          DigestMailer::MailOrchestrator.prepare({:scope => "by_invite_user_id", :id => @d1.id, :body => 'This email has a body'})
        end
        it { EmailDigest.count.should == 0 }
        it { EmailMessage.count.should == 1 }
        it { Delayed::Job.count.should == 1 }
    end
    
    describe "by_all_users" do
      before do
        DigestMailer::MailOrchestrator.prepare({:scope => "by_all_users", :body => 'This email has a body'})
      end
      it { User.count.should == 7 }
      it { EmailDigest.count.should == 4 }
      it { EmailMessage.count.should == 1 }
      it { Delayed::Job.count.should == 7 
        #Rails.logger.info(Delayed::Job.last.to_xml)
      }
    end 

    describe "by_all_users_with_idea_on_a_project" do
      before do 
        @idea = Factory.create(:idea, :user => @d1, :project => @project)
        @idea2 = Factory.create(:idea, :user => @d2, :project => @project)
        DigestMailer::MailOrchestrator.prepare({:scope =>'by_all_users_with_idea_on_a_project', :id => @project.id, :body => 'This email has a body.'}, ["test2@mail.com"])
      end

      it { @project.id.should > 0 }
      it { @project.users.count.should == 2 }
      it { EmailDigest.count.should == 0 } #because the scope says to skip user preferences
      it { EmailMessage.count.should == 1 } 
      it { Delayed::Job.count.should == 3
        work_off 
      } 
    end 

    describe "by_project_id" do
      before do 
        Factory.create(:membership, :memberable => @project, :user => @d5) 
        DigestMailer::MailOrchestrator.prepare({:scope =>'by_project_id', :id => @project.id, :body => 'This email has a body!'})
      end
      it { @project.users.count == 3 }
      it { EmailDigest.count.should == 0 } #because the scope says to skip user preferences
      it { EmailMessage.count.should == 1 } 
      it { Delayed::Job.count.should == 3 }
    end

    describe "by_discipline_id" do
      describe "should recognize that discipline 4 has 2 users in it" do
        before do
          DigestMailer::MailOrchestrator.prepare({:scope =>'by_discipline_id', :id => 4, :body => 'This email has a body'})
        end
        it { EmailDigest.count.should == 0 } #because the scope says to skip user preferences
        it { EmailMessage.count.should == 1 }
        it { Delayed::Job.count.should == 2 }
      end

      describe "should recognize that discipline 2 has 1 user in it" do
        before do
          DigestMailer::MailOrchestrator.prepare({:scope =>'by_discipline_id', :id => 2, :body => 'This email has a body'})
        end
        it { EmailDigest.count.should == 0 } #because the scope says to skip user preferences
        it { EmailMessage.count.should == 1 }
        it { Delayed::Job.count.should == 1 }
      end
    end

    describe "by_all_users_with_idea" do
      before do 
        Factory.create(:idea, :user => @d1, :project => @project)
        Factory.create(:idea, :user => @d2, :project => @project)
        Factory.create(:idea, :user => @d3, :project => @project)
        Factory.create(:idea, :user => @d4, :project => @project)
        Factory.create(:idea, :user => @d4_2, :project => @project)
        DigestMailer::MailOrchestrator.prepare({:scope =>'by_all_users_with_idea', :subject => 'This is a subject line', :body => 'This is the body of an email'}, ['test@mail.com'])
      end
      it { Idea.count.should > 0 }
      it { @project.users.count == 5 }
      it { EmailDigest.count.should == 0 } #because the scope says to skip user preferences
      it { EmailMessage.count.should == 1 }
      it "should enqueue the proper number of delayed jobs" do 
        Delayed::Job.count.should == 6
      end  
    end

  end

  pending "sending multiple emails to a digest user should queue them up without adding to the number delayed_jobs or email_digests"
 
end