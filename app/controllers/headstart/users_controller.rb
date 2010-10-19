class Headstart::UsersController < ApplicationController
  unloadable

  skip_before_filter :authenticate, :only => [:new, :create, :facebook_remove]
  before_filter :redirect_to_root,  :only => [:new, :create], :if => :signed_in?
  filter_parameter_logging :password
  # Before Filter on *only* the 'uninstalled' method 
  before_filter :verify_uninstall_signature, :only => [:facebook_remove] 
  skip_before_filter :verify_authenticity_token, :only => [:facebook_remove]
  before_filter :set_oauth_url, :only => [:new, :create]
  
  def resend_welcome_email
    HeadstartMailer.deliver_welcome(current_user)
    flash[:notice] = 'Your confirmation email has been resent.'
    @user = current_user
    render :template => 'users/edit'
  end
  
  def facebook_remove
    @fb_uid = params[:fb_sig_user] 
    if @fb_uid.present?
      # From here on it will be app specific -- given the facebook uid, destroy the user, like... 
      @user = User.find_by_facebook_uid(@fb_uid)
      @user.update_attribute(:facebook_removed, Time.now) if @user 
    end
    render :nothing => true; return 
  end
  
  def show
    @user = current_user
    render :template => 'users/show'
  end

  def new
    @user = ::User.new(params[:user])
    render :template => 'users/new'
  end

  def create
    @user = ::User.new params[:user]
    @user.email.downcase! if @user.email.present?
    if @user.save
      sign_in(@user)
      flash[:notice] = 'You have successfully signed up.'
      redirect_back_or(url_after_create)
    else
      render :template => 'users/new'
    end
  end
  
  def edit
    @user = current_user
    if !@user.email_confirmed?
      flash[:notice] = 'Your account has not been confirmed yet. Please confirm using the link in the Welcome email sent to you. Click <a href="/resend_welcome_email">here</a> to resend confirmation email.'
    end
    render :template => 'users/edit'
  end
  
  def update
    @user = current_user
    @user.email.downcase! if @user.email.present?
    if @user.update_attributes(params[:user])
      flash[:success] = 'Your profile has been updated.'
      redirect_back_or(user_path(@user))
    else
      render :template => 'users/edit'
    end
  end

  protected
  def verify_uninstall_signature
    signature = ''
    keys = params.keys.sort
    keys.each do |key|
      next if key == 'fb_sig'
      next unless key.include?('fb_sig')
      key_name = key.gsub('fb_sig_', '')
      signature += key_name
      signature += '='
      signature += params[key]
    end
    signature += Headstart.configuration.facebook_secret_key
    calculated_sig = Digest::MD5.hexdigest(signature)
    #logger.info "\nUNINSTALL :: Signature (fb_sig param from facebook) :: #{params[:fb_sig]}" 
    #logger.info "\nUNINSTALL :: Signature String (pre-hash) :: #{signature}" 
    #logger.info "\nUNINSTALL :: MD5 Hashed Sig :: #{calculated_sig}"
    if calculated_sig != params[:fb_sig] 
      #logger.warn "\n\nUNINSTALL :: WARNING :: expected signatures did not match\n\n" return false else 
      #logger.warn "\n\nUNINSTALL :: SUCCESS!! Signatures matched.\n" 
    end
    return true
  end 
    
  private

  def url_after_create
    root_url
  end
end
