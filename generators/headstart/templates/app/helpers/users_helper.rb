module UsersHelper
  
  def avatar_url(user)
    if user.facebook_uid.present? && user.avatar_file_name.blank?
      return "http://graph.facebook.com/#{user.facebook_uid}/picture?type=square"
    else
      return user.avatar.url(:thumb)
    end
  end
end
