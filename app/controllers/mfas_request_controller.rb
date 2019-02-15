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
    bank_acc_number = '1234567890' #Account number must be between 9 and 16 chars long
    ifsc_code = 'HDFC0000291' #IFSC code must be in the format: HDFC0000291

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
    bank_acc_number = '1234567890' #Account number must be between 9 and 16 chars long
    neft_code = 'HDFC0000291' #IFSC code must be in the format: HDFC0000291

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
