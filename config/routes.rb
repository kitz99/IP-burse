Team9Scholarships::Application.routes.draw do
  resources :periods

  resources :domains
  resources :news
  resources :home
  resources :attachments
  resources :document_types
  resources :scholarships
  resources :applications

  root :to => 'home#index'

  get '/auth/:provider/callback' => 'user_sessions#create'
  get '/auth/failure' => 'user_sessions#failure'

  get '/profile' => 'user_sessions#show_profile'
  put '/profile' => 'user_sessions#show_profile'


  put '/update' => "user_sessions#update"
  get '/update' => "user_sessions#show_profile"

  get '/logout' => 'user_sessions#destroy'

  get '/admin' => 'home#admin_index'
  get '/waiting' => 'home#admin_waiting'
  get '/requests' => 'home#admin_requests'
  get '/valid' => 'home#admin_valid'
  get '/generate' => 'home#generate'

  get '/review-news' => 'news#show_unpublished'
  get '/edit_unpublished/:news_id' => 'news#edit_unp'
  patch 'post_edit/:news_id' => 'news#post_edit'
  get '/delete/:news_id' => 'news#delete'

  post '/send_applications' => 'applications#create'

  delete 'delete_period/:per_id' => 'periods#delete'

  get 'datatable_i18n', to: 'home#datatable_i18n'

  get '/config-scholarship' => 'periods#defineScholarship'
  post '/define-scholarship' => 'periods#defineDocumentsForScholarship'

  get '/applications/:scholarship_id/new' => 'applications#new'
  put '/applications/:scholarship_id/new' => 'applications#new'

  get "/aplica" => 'applications#new'

  put '/inline' => 'applications#inline_edit'

  get '/applications/admin/:id' => 'applications#admin_show'
  put '/applications/admin_update/:id' => 'applications#admin_update'

  delete '/domains/data/:id' => 'domains#destroy_data'


  #not used 
  get '/json/waiting' => 'applications#get_waiting_applications'
  get '/json/valid' => 'applications#get_valid_applications'
  get '/json/accepted' => 'applications#get_accepted_applications'

  #used
  get '/json/all' => 'applications#get_applications'
  get '/json/jlm/' => 'applications#get_for_generate'
  get '/json/data/' => 'domains#get_data'


  


end
