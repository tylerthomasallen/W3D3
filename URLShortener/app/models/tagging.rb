# == Schema Information
#
# Table name: taggings
#
#  id     :bigint(8)        not null, primary key
#  tag_id :integer          not null
#  url_id :integer          not null
#

class Tagging < ApplicationRecord
  validates :tag_id, :url_id, presence: true
  
  belongs_to :url,
    primary_key: :id,
    foreign_key: :url_id,
    class_name: :ShortenedUrl
    
  belongs_to :tag,
    primary_key: :id,
    foreign_key: :tag_id,
    class_name: :TagTopic
  
end
