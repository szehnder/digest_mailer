class CreateDigestMailerTables < ActiveRecord::Migration
  def self.up
    create_table :email_logs do |t|
      t.references :user #not sure what this is used for, yet
      t.integer :recipient_id
      t.references :email_message
      t.datetime :intended_sent_at
      t.timestamps
    end
    
    create_table :email_digests do |t|
      t.references :user
      t.references :digest_type
      t.datetime :intended_sent_at
      t.timestamps
    end
    
    create_table :email_messages do |t|
      t.text :body
      t.string :from_email
      t.string :body_type #html or plain
      t.string :subject
      t.string :collation_type #individual, daily_digest, weekly_digest
      t.string :email_type #this will be the name of the email method, such as 'generic_message'
    end
    
    create_table :email_digests_email_messages, :id => false do |t|
      t.references :email_digest
      t.references :email_message
    end
    
    create_table :digest_types, :force => true do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :email_logs
    drop_table :email_digests
    drop_table :email_messages
    drop_table :email_digests_email_messages
    drop_table :digest_types
  end
  
end
