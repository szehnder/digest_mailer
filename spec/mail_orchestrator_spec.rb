require 'spec_helper'
require 'digest_mailer/mail_orchestrator'

describe DigestMailer::MailOrchestrator do

  before do 
    @member = Factory.create(:role)
    
    @project = Factory.create(:project)
    
    @d1 = Factory.create(:user)
    @d1.discipline_id = 1
    @d1.roles = [@member]
    @d1.receive_frequency = 'immediately'
    @d1.save!
          
     @d2 = Factory.create(:user)
     @d2.discipline_id = 2
     @d2.roles = [@member]
     @d2.receive_frequency = 'immediately'
     @d2.save!
     
     @d3 = Factory.create(:user)
     @d3.discipline_id = 3
     @d3.roles = [@member]
     @d3.receive_frequency = 'daily'
     @d3.save!
     
     @d4 = Factory.create(:user)
     @d4.discipline_id = 4
     @d4.roles = [@member]
     @d4.receive_frequency = 'daily'
     @d4.save!
     
     @d4_2 = Factory.create(:user)
     @d4_2.discipline_id = 4
     @d4_2.roles = [@member]
     @d4_2.receive_frequency = 'weekly'
     @d4_2.save!
     
     @d5 = Factory.create(:user)
     @d5.discipline_id = 5
     @d5.roles = [@member]
     @d5.receive_frequency = 'daily'
     @d5.save!
    
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
      end
    end
    
    describe "recipients_by_scope" do 
      before do
        @message_params = {:other_recipients => ['szehnder@victorsandspoils.com']}
        @idea = Factory.create(:idea)
        @idea2 = Factory.create(:idea2)
      end
      
      pending "should find one recipient for by_user_id" do
        DigestMailer::MailOrchestrator.recipients_by_scope('by_user_id', @message_params).count.should == 1
      end
      
      pending "should properly identify recipients by_project_id" do
        params = @message_params.clone
        params[:scope] = "#{params}|1"
        DigestMailer::MailOrchestrator.recipients_by_scope('by_project_id', params).count.should == 1
      end
      
      pending "should properly identify recipeints by_user_array" do
        DigestMailer::MailOrchestrator.recipients_by_scope('by_user_array', @message_params).count.should == 1
      end
      
      it "should properly identify recipients by_all_users" do
        DigestMailer::MailOrchestrator.recipients_by_scope('by_all_users', @message_params).count.should == 7
      end
      
      it "should properly identify recipients by_discipline_id" do
        params = @message_params.clone
        params[:scope] = "#{params}|4"
        DigestMailer::MailOrchestrator.recipients_by_scope('by_discipline_id', params).count.should == 3
      end
      
      it "should properly identify recipients by_invite_user_id" do
        params = @message_params.clone
        params[:scope] = "#{params}|2"
        DigestMailer::MailOrchestrator.recipients_by_scope('by_invite_user_id', params).count.should == 2
      end
      
      it "should properly identify recipients by_all_users_with_idea" do
        DigestMailer::MailOrchestrator.recipients_by_scope('by_all_users_with_idea', @message_params).count.should == 3
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
    
    describe "by_all_users" do
         before do
         end

         it "should enqueue a delayed job for all users" do
            lambda {
               DigestMailer::MailOrchestrator.prepare({:scope => "by_all_users"}, [])
             }.should change { Delayed::Job.count }.by(6)
        end
      end
  
end
