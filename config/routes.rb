Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Login
  post 'get_password', to: 'transactions#get_password_response', as: :get_password_response

  #Order Entry
  post 'order_entry', to: 'transactions#order_entry', as: :order_entry

  #Sip Order Entry
  post 'sip_order_entry', to: 'transactions#sip_order_entry', as: :sip_order_entry

  #XSip Order Entry
  post 'xsip_order_entry', to: 'transactions#xsip_order_entry', as: :xsip_order_entry

  #Spread Order Entry
  post 'spread_order_entry', to: 'transactions#spread_order_entry', as: :spread_order_entry

  #Switch Order Entry
  post 'switch_order_entry', to: 'transactions#switch_order_entry', as: :switch_order_entry

  #get encrypted password
  post 'mfa_get_password', to: 'mfas_request#mfa_get_password', as: :mfa_get_password
  #MUTUAL FUND Additional Services Request
  post 'mfa_service/fatca', to: 'mfas_request#mfa_service_fatca_request', as: :mfa_fatca
  post 'mfa_service/ucc-mfd', to: 'mfas_request#mfa_service_ucc_request', as: :mfa_ucc_mfd
  post 'mfa_service/payment-gateway',to: 'mfas_request#mfa_service_get_payment', as: :mfa_payment_gateway
  post 'mfa_service/change-password',to: 'mfas_request#mfa_service_change_password', as: :mfa_change_password
  post 'mfa_service/ucc-mfi',to: 'mfas_request#mfa_service_ucc_mfi', as: :mfa_service_ucc_mfi
  post 'mfa_service/mandate-registration', to: 'mfas_request#mfa_service_mandate',  as: :mfa_service_mandate
  post 'mfa_service/stp-registration', to: 'mfas_request#mfa_service_stp',  as: :mfa_service_stp
  post 'mfa_service/swp-registration', to: 'mfas_request#mfa_service_swp',  as: :mfa_service_swp
end
