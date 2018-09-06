# == Schema Information
#
# Table name: tag_topics
#
#  id    :bigint(8)        not null, primary key
#  topic :string           not null
#

class TagTopic < ApplicationRecord
  validates :topic, uniqueness: true
  
  has_many :taggings,
    primary_key: :id,
    foreign_key: :tag_id,
    class_name: :Tagging
    
  has_many :links,
    through: :taggings,
    source: :url
  
  TOPICS = ['sports', 'news', 'music', 'business']
  def self.create_topics
    TOPICS.each { |t| TagTopic.create(topic: t) }
  end
  
  def popular_links
    sorted = self.links.sort_by { |link| link.num_uniques }
    sorted.reverse[0..4].map { |url| "Url: #{url.long_url}, Visits: #{url.num_clicks}" }
  end
  
end 
