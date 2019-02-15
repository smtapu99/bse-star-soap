module MfaServiceHelper
  MFA_FLAGS = {
      :fatca_upload => '01',
      :ucc_mfd => '02',
      :payment_gateway => '03',
      :change_password => '04',
      :ucc_mfi => '05',
      :mandate_registration => '06',
      :stp_registration => '07',
      :swp_registration => '08',
      :stp_cancellation => '09',
      :swp_cancellation => '10',
      :client_order_payment_status => '11',
      :client_redemption_sms_authentication=> '12',
      :ckyc_upload => '13',
      :mandate_status => '14',
      :systematic_plan_authentication => '15'
  }
end
