class User < ActiveRecord::Base
  include Headstart::User
  
  # If we don't want the originals, add , :original => "1x1"
  has_attached_file :avatar, :styles => { :thumb => "50x50#", :mid => "200x300" }, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", 
       :path => ":class/:id/:style.:extension", :default_url => "/images/missing.jpg"
end
