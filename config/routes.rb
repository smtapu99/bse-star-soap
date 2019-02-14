Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Login
  post 'get_password', to: 'apis#get_password_response', as: :get_password_response

  #Order Entry Param
  post 'order_entry_param', to: 'apis#order_entry_param', as: :order_entry_param

  #Sip Order Entry Param
  post 'sip_order_entry_param', to: 'apis#sip_order_entry_param', as: :sip_order_entry_param

  #XSip Order Entry Param
  post 'xsip_order_entry_param', to: 'apis#xsip_order_entry_param', as: :xsip_order_entry_param

  #Spread Order Entry Param
  post 'spread_order_entry_param', to: 'apis#spread_order_entry_param', as: :spread_order_entry_param

  #Switch Order Entry Param
  post 'switch_order_entry_param', to: 'apis#switch_order_entry_param', as: :switch_order_entry_param

  #get encrypted password
  post 'mfa_get_password', to: 'mfas_request#mfa_get_password', as: :mfa_get_password
  #MUTUAL FUND Additional Services Request
  post 'mfa_service/fatca', to: 'mfas_request#mfa_service_fatca_request', as: :mfa_fatca
  post 'mfa_service/ucc-mfd', to: 'mfas_request#mfa_service_ucc_request', as: :mfa_ucc_mfd
end
