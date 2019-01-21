Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Login
  post 'get_password', to: 'apis#get_password_response', as: :get_password_response

  #Order Entry Param
  post 'order_entry_param', to: 'apis#order_entry_param', as: :order_entry_param

  #Sip Order Entry Param
  post 'sip_order_entry_param', to: 'apis#sip_order_entry_param', as: :sip_order_entry_param

end
