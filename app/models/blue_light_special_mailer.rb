class BlueLightSpecialMailer

  def self.deliver_change_password(user)
    if MadMimiMailer.api_settings.present? && MadMimiMailer.api_settings[:username].present? && MadMimiMailer.api_settings[:api_key].present?
      MimiMailer.deliver_mimi_change_password(user)
    else
      GenericMailer.deliver_mimi_change_password(user)
    end
  end
  
  def self.deliver_welcome(user)
    if MadMimiMailer.api_settings.present? && MadMimiMailer.api_settings[:username].present? && MadMimiMailer.api_settings[:api_key].present?
      MimiMailer.deliver_generic_welcome(user)
    else
      GenericMailer.deliver_generic_welcome(user)
    end
  end

end
