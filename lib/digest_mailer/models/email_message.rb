class EmailMessage < ActiveRecord::Base
    has_many :email_logs
    #has_and_belongs_to_many :email_digests
end
