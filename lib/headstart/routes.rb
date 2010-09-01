module Headstart
  class Routes

    # In your application's config/routes.rb, draw Headstart's routes:
    #
    # @example
    #   map.resources :posts
    #   Headstart::Routes.draw(map)
    #
    # If you need to override a Headstart route, invoke your app route
    # earlier in the file so Rails' router short-circuits when it finds
    # your route:
    #
    # @example
    #   map.resources :users, :only => [:new, :create]
    #   Headstart::Routes.draw(map)
    def self.draw(map)
      map.resources :passwords,
        :controller => 'headstart/passwords',
        :only       => [:new, :create]

      map.resource  :session,
        :controller => 'headstart/sessions',
        :only       => [:new, :create, :destroy]

      map.resources :users, :controller => 'headstart/users' do |users|
        users.resource :password,
          :controller => 'headstart/passwords',
          :only       => [:create, :edit, :update]
          
        users.resource :confirmation,
          :controller => 'headstart/confirmations',
          :only       => [:new, :create]
      end
      
      map.resource :impersonation,
        :controller => 'headstart/impersonations',
        :only       => [:create, :destroy]
      map.resources :impersonations,
        :controller => 'headstart/impersonations',
        :only       => :index
        
      map.sign_up    'sign_up',
        :controller   => 'headstart/users',
        :action       => 'new'
      map.sign_in    'sign_in',
        :controller   => 'headstart/sessions',
        :action       => 'new'
      map.fb_connect 'fb_connect',
        :controller   => 'headstart/sessions',
        :action       => 'create'
      map.fb_disconnect 'fb_disconnect',
        :controller   => 'headstart/users',
        :action       => 'facebook_remove'
      map.sign_out   'sign_out',
        :controller   => 'headstart/sessions',
        :action       => 'destroy',
        :method       => :delete
      map.admin      'admin', 
        :controller   => '/admin/admin',
        :action       => :index

      map.root :controller => "sessions", :action => 'index'
    end

  end
end
