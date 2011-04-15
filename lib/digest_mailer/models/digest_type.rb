class DigestType < ActiveRecord::Base
  has_many :email_digests
  validates_uniqueness_of :name
  validates_presence_of :name
end