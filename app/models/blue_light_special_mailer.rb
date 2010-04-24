class BlueLightSpecialMailer

  def self.deliver_change_password(user)
    if MadMimiMailer.api_settings.present? && MadMimiMailer.api_settings[:username].present? && MadMimiMailer.api_settings[:api_key].present?
      MimiMailer.deliver_mimi_change_password(user)
    else
      GenericMailer.deliver_change_password(user)
    end
  end
  
  def self.deliver_welcome(user)
    if MadMimiMailer.api_settings.present? && MadMimiMailer.api_settings[:username].present? && MadMimiMailer.api_settings[:api_key].present?
      MimiMailer.deliver_welcome(user)
    else
      GenericMailer.deliver_welcome(user)
    end
  end
  
  def self.deliver_confirmation(user)
    if MadMimiMailer.api_settings.present? && MadMimiMailer.api_settings[:username].present? && MadMimiMailer.api_settings[:api_key].present?
      MimiMailer.deliver_confirmation(user)
    else
      GenericMailer.deliver_confirmation(user)
    end
  end
  

end
