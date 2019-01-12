Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Login
  get 'get_password', to: 'get_password#get_password_response', as: :get_password_response
end
