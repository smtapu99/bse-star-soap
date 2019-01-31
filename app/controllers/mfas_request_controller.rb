class MfasRequestController < ApplicationController

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
    # Respond converted json response
    # if result_code.to_i == 100
    #   # result_message
    #   render status: 200, json: {
    #       status: "success",
    #       response_code: result_code,
    #       auth_token: result_message  # if success, result_message will be "new password"
    #   }.to_json
    # else
    #   # raise result_message
    #   render status: 200, json: {
    #       status: "fail",
    #       code: result_code,
    #       message: result_message # if failed, result_message will be alert message
    #   }.to_json
    # end
  end
  ## MUTUAL FUND Additional Services Request
  def mfa_service_request

    encrypted_password_response = mfa_get_password(params[:user_id], params[:member_id], params[:password], params[:pass_key])

    if encrypted_password_response[0].to_i == 100
      soap_header = generate_header(METHOD_UPLOAD_URL[LIVE] + 'MFAPI', SVC_UPLOAD_URL[LIVE])

      # create a client for the service
      client = get_soap_client(WSDL_UPLOAD_URL[LIVE], soap_header, get_mfapi_namespaces)

      fatca_flag = "01"
      fatca_dict = {
          :PAN_RP => 'NIGHT1996W',
          :PEKRN => '',
          :INV_NAME => 'Jon',
          :DOB => '',
          :FR_NAME => '',
          :SP_NAME => '',
          :TAX_STATUS => '01',
          :DATA_SRC => 'E',
          :ADDR_TYPE => '1',
          :PO_BIR_INC => 'IN',
          :CO_BIR_INC => 'IN',
          :TAX_RES1 => 'IN',
          :TPIN1 => 'NIGHT1996W',
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
          :SRCE_WEALT => '01',
          :CORP_SERVS => '',
          :INC_SLAB => '31',
          :NET_WORTH => '',
          :NW_DATE => '',
          :PEP_FLAG => 'N',
          :OCC_CODE => '01',
          :OCC_TYPE => 'B',
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

      fatca_param = []
      fatca_dict.each do |key, value|
        fatca_param << value
      end
      data = {
          "Flag" => fatca_flag,
          "UserId" => params[:user_id],
          "EncryptedPassword" => encrypted_password_response[1],
          "param" => fatca_param.join("|")
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
