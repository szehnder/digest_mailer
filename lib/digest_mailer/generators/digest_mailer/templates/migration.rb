class CreateDigestMailerTables < ActiveRecord::Migration
  def self.up
    create_table :email_logs do |t|
      t.references :user
      t.string :to
      t.text :body_plain
      t.text :body_html
      t.string :from
      t.string :subject
      t.datetime :intended_sent_at
      t.timestamps
    end
    create_table :email_digests do |t|
      t.references :user
      t.string :to
      t.string :frequency
      t.text :body_plain
      t.text :body_html
      t.string :from
      t.string :subject
      t.datetime :intended_sent_at
      t.timestamps
    end
  end

  def self.down
    drop_table :email_logs
    drop_table :email_digests
  end
end
