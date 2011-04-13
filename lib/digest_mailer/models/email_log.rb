class EmailLog < ActiveRecord::Base
  attr_accessible :body_html, :body_plain, :from, :to, :subject, :user_id, :intended_sent_at
end
