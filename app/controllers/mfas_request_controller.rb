class MfasRequestController < ApplicationController

  include MfaServiceHelper
  def mfa_get_password(user_id, member_id, password, pass_key)
    soap_header = generate_header(METHOD_UPLOAD_URL[LIVE] + 'getPassword', SVC_UPLOAD_URL[LIVE]) # "xmlns:ns3" => "http://www.w3.org/2005/08/addressing"

    # create a client for the service
    client = get_soap_client(WSDL_UPLOAD_URL[LIVE], soap_header, get_mfapi_namespaces)

    data = {
        "UserId" => user_id,
        "MemberId" => member_id,
        "Password" => password,
        "PassKey" => pass_key
    }
    # soap_actions = client.operations

    response = call_soap_client(client, 'get_password', data)
    hash = response.hash
    result_string = hash['envelope']['body']['get_password_response']['get_password_result']
    result_code = result_string.split('|').first
    result_message = result_string.split('|').last

    [result_code, result_message]

  end

  ## MUTUAL FUND Additional Services-FATCA Request
  def mfa_service_fatca_request
    flag = MFA_FLAGS[:fatca_upload]
    pan = 'NIGHT1996W'
    tax_status = '01'
    occ_code = '01'
    if occ_code == '01'
      srce_wealt = '02'
      occ_type = 'B'
    else
      srce_wealt = '01'
      occ_type = 'S'
    end
    dict = {
        :PAN_RP => pan,
        :PEKRN => '',
        :INV_NAME => 'Jon',
        :DOB => '',
        :FR_NAME => '',
        :SP_NAME => '',
        :TAX_STATUS => tax_status,
        :DATA_SRC => 'E',
        :ADDR_TYPE => '1',
        :PO_BIR_INC => 'IN',
        :CO_BIR_INC => 'IN',
        :TAX_RES1 => 'IN',
        :TPIN1 => pan,
        :ID1_TYPE => 'C',
        :TAX_RES2 => '',
        :TPIN2 => '',
        :ID2_TYPE => '',
        :TAX_RES3 => '',
        :TPIN3 => '',
        :ID3_TYPE => '',
        :TAX_RES4 => '',
        :TPIN4 => '',
        :ID4_TYPE => '',
        :SRCE_WEALT => srce_wealt,
        :CORP_SERVS => '',
        :INC_SLAB => '31',
        :NET_WORTH => '',
        :NW_DATE => '',
        :PEP_FLAG => 'N',
        :OCC_CODE => occ_code,
        :OCC_TYPE => occ_type,
        :EXEMP_CODE => '',
        :FFI_DRNFE => '',
        :GIIN_NO => '',
        :SPR_ENTITY => '',
        :GIIN_NA => '',
        :GIIN_EXEMC => '',
        :NFFE_CATG => '',
        :ACT_NFE_SC => '',
        :NATURE_BUS => '',
        :REL_LISTED => '',
        :EXCH_NAME => 'O',
        :UBO_APPL => 'N',
        :UBO_COUNT => '',
        :UBO_NAME => '',
        :UBO_PAN => '',
        :UBO_NATION => '',
        :UBO_ADD1 => '',
        :UBO_ADD2 => '',
        :UBO_ADD3 => '',
        :UBO_CITY => '',
        :UBO_PIN => '',
        :UBO_STATE => '',
        :UBO_CNTRY => '',
        :UBO_ADD_TY => '',
        :UBO_CTR => '',
        :UBO_TIN => '',
        :UBO_ID_TY => '',
        :UBO_COB => '',
        :UBO_DOB => '',
        :UBO_GENDER => '',
        :UBO_FR_NAM => '',
        :UBO_OCC => '',
        :UBO_OCC_TY => '',
        :UBO_TEL => '',
        :UBO_MOBILE => '',
        :UBO_CODE => 'C01',
        :UBO_HOL_PC => '',
        :SDF_FLAG => '',
        :UBO_DF => 'N',
        :AADHAAR_RP => '',
        :NEW_CHANGE => 'N',
        :LOG_NAME => '196.15.16.107#29-Jan-19;16:4',
        :DOC1 => '',
        :DOC2 => ''
    }
    mfa_service_request(flag, dict)
  end

  ## MUTUAL FUND Additional Services-UCC-MFD Request
  # Creates a user on BSEStar (called client in bse lingo)
  def mfa_service_ucc_request
    flag = MFA_FLAGS[:ucc_mfd]
    pan = 'NIGHT1996W'
    tax_status = '01'
    occ_code = '01'
    bank_acc_type = 'SB' # SB: Savings, CB: Current, NE: NRE, NO: NRO
    bank_acc_number = '100200324786' #Account number must be between 9 and 16 chars long
    ifsc_code = 'HDFC0000060' #IFSC code must be in the format: HDFC0000060

    address = "Squire to the Lord Commander of the Night's Watch"
    add1 = address[0...30]
    add2 = address.length > 30 ? address[30...60] : ''
    add3 = address.length > 60 ? address[60...90] : ''
    email = 'fatpig0416@gmail.com'
    pin_code = '110001'
    city = 'The Wall'
    state = 'MA'
    phone = '9167783870'


    dict = { #params that will be sent as param for user creation in bse
             :CODE => 1,
             :HOLDING => 'SI',
             :TAXSTATUS => tax_status,
             :OCCUPATIONCODE => occ_code,
             :APPNAME1 => 'Jon',
             :APPNAME2 => '',
             :APPNAME3 => '',
             :DOB => '16/04/1993',
             :GENDER => 'M',
             :FATHER_HUSBAND_GUARDIAN => '',
             :PAN => pan,
             :NOMINEE => '',
             :NOMINEE_RELATION => '',
             :GUARDIANPAN => '',
             :TYPE => 'P',
             :DEFAULTDP => '',
             :CDSLDPID => '',
             :CDSLCLTID => '',
             :NSDLDPID => '',
             :NSDLCLTID => '',
             :ACCTYPE_1 => bank_acc_type,
             :ACCNO_1 => bank_acc_number,
             :MICRNO_1 => '',
             :NEFT_IFSCCODE_1 => ifsc_code,
             :DEFAULT_BANK_FLAG_1 => 'Y',
             :ACCTYPE_2 => '',
             :ACCNO_2 => '',
             :MICRNO_2 => '',
             :NEFT_IFSCCODE_2 => '',
             :DEFAULT_BANK_FLAG_2 => '',
             :ACCTYPE_3 => '',
             :ACCNO_3 => '',
             :MICRNO_3 => '',
             :NEFT_IFSCCODE_3 => '',
             :DEFAULT_BANK_FLAG_3 => '',
             :ACCTYPE_4 => '',
             :ACCNO_4 => '',
             :MICRNO_4 => '',
             :NEFT_IFSCCODE_4 => '',
             :DEFAULT_BANK_FLAG_4 => '',
             :ACCTYPE_5 => '',
             :ACCNO_5 => '',
             :MICRNO_5 => '',
             :NEFT_IFSCCODE_5 => '',
             :DEFAULT_BANK_FLAG_5 => '',
             :CHEQUENAME => '',
             :ADD1 => add1,
             :ADD2 => add2,
             :ADD3 => add3,
             :CITY => city,
             :STATE => state,
             :PINCODE => pin_code,
             :COUNTRY => 'India',
             :RESIPHONE => '',
             :RESIFAX => '',
             :OFFICEPHONE => '',
             :OFFICEFAX => '',
             :EMAIL => email,
             :COMMMODE => 'M',
             :DIVPAYMODE => '02',
             :PAN2 => '',
             :PAN3 => '',
             :MAPINNO => '',
             :CM_FORADD1 => '',
             :CM_FORADD2 => '',
             :CM_FORADD3 => '',
             :CM_FORCITY => '',
             :CM_FORPINCODE => '',
             :CM_FORSTATE => '',
             :CM_FORCOUNTRY => '101', #India
             :CM_FORRESIPHONE => '',
             :CM_FORRESIFAX => '',
             :CM_FOROFFPHONE => '',
             :CM_FOROFFFAX => '',
             :CM_MOBILE => phone,
    }
    mfa_service_request(flag, dict)
  end

  ## fire SOAP query to get the payment url
  # create payment
  def mfa_service_payment_gateway
    flag = MFA_FLAGS[:payment_gateway]
    dict = {
        :member_id => params[:member_id],
        :client_code => params[:client_code],
        :logout_url => params[:logout_url]
    }
    mfa_service_request(flag, dict)
  end

  # Change password
  def mfa_service_change_password
    flag = MFA_FLAGS[:change_password]
    dict = {
        :old_password => params[:password],
        :new_password => params[:new_password],
        :conf_password => params[:conf_password]
    }
    mfa_service_request(flag, dict)
  end

  # UCC/CLIENT CREATION– MFI
  def mfa_service_ucc_mfi
    flag = MFA_FLAGS[:ucc_mfi]
    pan = 'NIGHT1996W'
    tax_status = '01'
    occ_code = '01'
    bank_acc_type = 'SB' # SB: Savings, CB: Current, NE: NRE, NO: NRO
    bank_acc_number = '100200324786' #Account number must be between 9 and 16 chars long
    neft_code = 'HDFC0000060' #IFSC code must be in the format: HDFC0000060

    address = "Squire to the Lord Commander of the Night's Watch"
    add1 = address[0...30]
    add2 = address.length > 30 ? address[30...60] : ''
    add3 = address.length > 60 ? address[60...90] : ''
    email = 'fatpig0416@gmail.com'
    pin_code = '110001'
    city = 'The Wall'
    state = 'MA'
    dict = {
        :CODE => 1,
        :HOLDING => 'SI',
        :TAXSTATUS => tax_status,
        :OCCUPATIONCODE => occ_code,
        :APPNAME1 => 'Jon',
        :APPNAME2 => '',
        :APPNAME3 => '',
        :DOB => '16/04/1993',
        :GENDER => 'M',
        :FATHER_HUSBAND_GUARDIAN => '',
        :PAN => pan,
        :NOMINEE => '',
        :NOMINEE_RELATION => '',
        :GUARDIANPAN => '',
        :DEFAULTDP => '',
        :CDSLDPID => '',
        :CDSLCLTID => '',
        :NSDLDPID => '',
        :NSDLCLTID => '',
        :BANK_NAME => 'INDIAN',
        :BANK_BRANCH => 'GITAM UNIVERSITY',
        :BANK_CITY => 'ANDHRA PRADESH',
        :ACCTYPE => bank_acc_type,
        :ACCNO => bank_acc_number,
        :MICRNO => '',
        :NEFT_CODE => neft_code,
        :CHEQUENAME => '',
        :ADD1 => add1,
        :ADD2 => add2,
        :ADD3 => add3,
        :CITY => city,
        :STATE => state,
        :PINCODE => pin_code,
        :COUNTRY => 'India',
        :RESIPHONE => '',
        :RESIFAX => '',
        :OFFICEPHONE => '',
        :OFFICEFAX => '',
        :EMAIL => email,
        :COMMMODE => 'M',
        :DIVPAYMODE => '02',
        :PAN2 => '',
        :PAN3 => '',
        :MAPINNO => '',
        :CM_FORADD1 => '',
        :CM_FORADD2 => '',
        :CM_FORADD3 => '',
        :CM_FORCITY => '',
        :CM_FORPINCODE => '',
        :CM_FORSTATE => '',
        :CM_FORCOUNTRY => '101', #India
        :CM_FORRESIPHONE => '',
        :CM_FORRESIFAX => '',
        :CM_FOROFFPHONE => '',
        :CM_FOROFFFAX => ''
    }
    mfa_service_request(flag, dict)
  end

  # MANDATE REGISTRATION, XSIP/ISIP Mandate: Member Type: MFI/MFD
  def mfa_service_mandate
    flag = MFA_FLAGS[:mandate_registration]
    bank_acc_type = 'SB' # SB: Savings, CB: Current, NE: NRE, NO: NRO
    bank_acc_number = '100200324786' #Account number must be between 9 and 16 chars long
    ifsc_code = 'HDFC0000060' #IFSC code must be in the format: HDFC0000060
    dict = {
        :client_code => params[:client_code],
        :amount => params[:amount],
        :mandate_type => params[:mandate_type].try(:upcase), #X / I /E (XSIP/ISIP/ E-Mandate)
        :account_no => params[:acount_no] || bank_acc_number,
        :a_c_type => params[:bank_account_type].try(:upcase) || bank_acc_type, #A/C TYPE , SB/CB/NE/NO
        :ifsc_code => params[:ifsc_code] || ifsc_code,
        :micr_code => params[:micr_code] || '',
        :start_date => params[:start_date], #DD/MM/YY
        :end_date => params[:end_date] #DD/MM/YYYY Default date would be current date + 100 years.
    }
    mfa_service_request(flag, dict)
  end

  # STP Registration via Webservices
  def mfa_service_stp_reg
    flag = MFA_FLAGS[:stp_registration]
    dict = {
        :client_code => params[:client_code],
        :from_scheme_code => params[:from_scheme_code],
        :to_scheme_code => params[:to_scheme_code],
        :buy_sell_type => params[:buy_sell_type], # Fresh/Additional
        :trans_mode => params[:trans_mode].try(:upcase),# D/P, demat or physica
        :folio_no => params[:folio_no],#Incase demat transaction this field will be blank and mandatory in case of physical redemption and purchase+additional
        :internal_ref_no => params[:internal_ref_no],
        :start_date => params[:start_date], #DD/MM/YY
        :frequency_type => params[:frequency_type].try(:upcase), #type of requency , MONTHLY/QUARTERLY/WEEKLY
        :no_of_transfers => params[:no_of_transfers],
        :installment_amount => params[:installment_amount],#installment amount
        :first_order_today => params[:first_order_today].try(:upcase), #Y/N
        :sub_br_code => params[:sub_br_code],
        :euin_declaration => params[:euin_declaration].try(:upcase), #Y/N
        :euin_number => params[:euin_number],
        :remarks => params[:remarks],
        :sub_br_arn => params[:sub_broker_arn]

    }
    mfa_service_request(flag, dict)
  end

  # WP Registration via Webservices
  def mfa_service_swp_reg
    flag = MFA_FLAGS[:swp_registration]
    dict = {
        :client_code => params[:client_code],
        :scheme_code => params[:scheme_code],
        :trans_mode => params[:trans_mode].try(:upcase),# D/P, demat or physica
        :folio_no => params[:folio_no],#Incase demat transaction this field will be blank and mandatory in case of physical redemption and purchase+additional
        :internal_ref_no => params[:internal_ref_no],
        :start_date => params[:start_date], #DD/MM/YY
        :number_of_withdrawls => params[:number_of_withdrawls],
        :frequency_type => params[:frequency_type].try(:upcase), #type of requency , MONTHLY/QUARTERLY/WEEKLY
        :installment_amount => params[:installment_amount],#installment amount
        :installment_units => params[:installment_units],#installment amount
        :first_order_today => params[:first_order_today].try(:upcase), #Y/N
        :sub_br_code => params[:sub_br_code],
        :euin_declaration => params[:euin_declaration].try(:upcase), #Y/N
        :euin_number => params[:euin_number],
        :remarks => params[:remarks],
        :sub_br_arn => params[:sub_broker_arn]

    }
    mfa_service_request(flag, dict)
  end

  # STP Cancellation via Webservices
  def mfa_service_stp_cancel
    flag = MFA_FLAGS[:stp_cancellation]
    dict = {
        :stp_registration_no => params[:stp_registration_no],
        :client_code => params[:client_code],
        :remarks => params[:remarks] || ''
    }
    mfa_service_request(flag, dict)
  end

  # STP Cancellation via Webservices
  def mfa_service_swp_cancel
    flag = MFA_FLAGS[:swp_cancellation]
    dict = {
        :swp_registration_no => params[:swp_registration_no],
        :client_code => params[:client_code],
        :remarks => params[:remarks] || ''
    }
    mfa_service_request(flag, dict)
  end

  # CLIENT ORDER PAYMENT STATUS
  def mfa_service_payment_status
    flag = MFA_FLAGS[:client_order_payment_status]
    dict = {
        :client_code => params[:client_code],
        :order_no => params[:order_no],
        :segment => 'BSEMF' # BSEMF- when MF Order is placed, SGB- when SGB order is placed
    }
    mfa_service_request(flag, dict)
  end

  # CLIENT REDEMPTION SMS AUTHENTICATION
  def mfa_service_sms_auth
    flag = MFA_FLAGS[:client_redemption_sms_authentication]
    dict = {
        :member_code => params[:member_id],
        :client_code => params[:client_code],
    }
    mfa_service_request(flag, dict)
  end

  # CKYC via Webservices
  def mfa_service_ckyc_upload
    flag = MFA_FLAGS[:ckyc_upload]
    pan = 'NIGHT1996W'
    dict = {
        :client_code => params[:client_code],
        :pan => params[:client_pan] || pan, #Mandatory if Tax Status is not 02 (Should Match with Existing PAN Given for Client Code)
        :holder_ckyc_number_1 => params[:holder_ckyc_number_1],
        :holder_ckyc_number_2 => params[:holder_ckyc_number_2],
        :holder_ckyc_number_3 => params[:holder_ckyc_number_3],
        :guardian_ckyc_number => params[:guardian_ckyc_number],
        :joint_holder_1_dob => params[:joint_holder_1_dob],
        :joint_holder_2_dob => params[:joint_holder_2_dob],
        :guardian_ckyc_dob => params[:guardian_ckyc_dob],
        :kyc_type_1_holder => params[:kyc_type_1_holder], #(K/C) (K - KRA Compliant C- CKYC Compliant)
        :kyc_type_2_holder => params[:kyc_type_2_holder],
        :kyc_type_3_holder => params[:kyc_type_3_holder],
        :kyc_type_guardian => params[:kyc_type_guardian],

    }
    mfa_service_request(flag, dict)
  end

  # MANDATE STATUS
  def mfa_service_mandate_status
    flag = MFA_FLAGS[:mandate_status]
    dict = {
        :from_date => params[:from_date],
        :to_date => params[:to_date],
        :member_code => params[:member_id],
        :client_code => params[:client_code],
        :mandate_id => params[:mandate_id]
    }
    mfa_service_request(flag, dict)
  end

  # SYSTEMATIC PLAN AUTHENTICATION (Registration/ Cancellation)
  def mfa_service_sys_plan_auth
    flag = MFA_FLAGS[:systematic_plan_authentication]
    dict = {
        :action => params[:plan_action].try(:upcase), #NEW/CXL
        :member_code => params[:member_id],
        :client_code => params[:client_code],
        :logout_url => params[:logout_url]
    }
    mfa_service_request(flag, dict)
  end
  ## MUTUAL FUND Additional Services Request
  def mfa_service_request(flag, dict)

    encrypted_password_response = mfa_get_password(params[:user_id], params[:member_id], params[:password], params[:pass_key])

    if encrypted_password_response[0].to_i == 100
      soap_header = generate_header(METHOD_UPLOAD_URL[LIVE] + 'MFAPI', SVC_UPLOAD_URL[LIVE])

      # create a client for the service
      client = get_soap_client(WSDL_UPLOAD_URL[LIVE], soap_header, get_mfapi_namespaces)

      mfa_param = []
      dict.each do |key, value|
        mfa_param << value
      end
      data = {
          "Flag" => flag,
          "UserId" => params[:user_id],
          "EncryptedPassword" => encrypted_password_response[1],
          "param" => mfa_param.join("|")
      }

      response = call_soap_client(client, 'mfapi', data)
      hash = response.hash
      result_string = hash['envelope']['body']['mfapi_response']['mfapi_result']
      result = result_string.split('|')
      # Respond converted json response
      if result.first.to_i == 100
        render status: 200, json: {
            status: "success",
            code: result.first,
            message: result.last
        }.to_json
      else
        # raise result_message
        render status: 200, json: {
            status: "fail",
            code: result.first,
            message: result.last
        }.to_json
      end
    else
      # raise get password error
      render status: 200, json: {
          status: "fail",
          code: encrypted_password_response[0],
          message: encrypted_password_response[1]
      }.to_json
    end
  end
end
