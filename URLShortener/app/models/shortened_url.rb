# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  short_url  :string
#  long_url   :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true
  
  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User
    
  has_many :visits,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Visit
    
  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :user
    
  has_many :taggings,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :Tagging
    
  has_many :tags,
    through: :taggings,
    source: :tag  

  
  def self.random_code 
    short = SecureRandom.urlsafe_base64()
    while ShortenedUrl.exists?(short_url: short)
      short = SecureRandom.urlsafe_base64()
    end 
    short
  end 
  
  def self.shorten_url(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create(long_url: long_url, short_url: short_url, user_id: user.id)
  end
  

  def num_clicks
    self.visits.length
  end
  
  def num_uniques
    self.visitors.length
  end
    
  def num_recent_uniques
    
    Visit.where({url_id: :id, created_at: (Time.now)..10.minutes.ago})
  end  
  
end
