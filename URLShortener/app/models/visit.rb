# == Schema Information
#
# Table name: visits
#
#  id              :bigint(8)        not null, primary key
#  user_id         :integer          not null
#  shortenedurl_id :integer          not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Visit < ApplicationRecord
  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user.id, shortenedurl_id: shortened_url.id)
  end
  
  belongs_to :visitor,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User
  
  
  belongs_to :visited_url,
    primary_key: :id,
    foreign_key: :shortenedurl_id,
    class_name: :ShortenedUrl
  
  
  validates :user_id, presence: true
  validates :shortenedurl_id, presence: true
end
