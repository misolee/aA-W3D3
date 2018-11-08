# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  def self.random_code
    a = SecureRandom::urlsafe_base64
    unless self.exists?(short_url: a)
      return a
    else
      self.random_code
    end
  end
  
  def self.create!(long_url, user)
    ShortenedUrl.create(long_url: long_url, user_id: user.id, short_url: ShortenedUrl.random_code)
  end
  
  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User
    
  has_many :visits,
    primary_key: :id,
    foreign_key: :shortenedurl_id,
    class_name: :Visit
    
  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitor
    
  def num_clicks
    visits.count
  end
  
  def num_uniques
    #visits.select(:user_id).distinct.count
    visitors.count
  end
  
  def num_recent_uniques
    visits.select(:user_id).distinct.where({created_at: 10.minutes.ago..Time.now}).count
  end
  
  validates :short_url, presence: true, uniqueness: true
  validates :long_url, presence: true
  validates :user_id, presence: true
end
