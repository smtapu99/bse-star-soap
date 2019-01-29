class ApisController < ApplicationController

  include TransactionHelper
  ################ SOAP FUNCTIONS to get/post data - called by MAIN FUNCTIONS

  ## fire SOAP query to get password for Order API endpoint
  ## used by create_transaction_bse() and cancel_transaction_bse()
  def get_password_response
    soap_header = generate_header(METHOD_ORDER_URL[LIVE] + 'getPassword', SVC_ORDER_URL[LIVE]) # "xmlns:ns3" => "http://www.w3.org/2005/08/addressing"

    # create a client for the service
    client = get_soap_client(WSDL_ORDER_URL[LIVE], soap_header)

    data = {
        "UserId" => params[:user_id],
        "Password" => params[:password],
        "PassKey" => params[:pass_key]
    }
    # soap_actions = client.operations

    response = call_soap_client(client, 'get_password', data)
    hash = response.hash
    result_string = hash['envelope']['body']['get_password_response']['get_password_result']

    ## Http status
    success = response.success?     # => true
    fault = response.soap_fault?  # => false
    error = response.http_error?  # => false
    ## Http status end

    result_code = result_string.split('|').first
    result_message = result_string.split('|').last

    # Respond converted json response
    if result_code.to_i == 100
      # result_message
      render status: 200, json: {
          status: "success",
          response_code: result_code,
          auth_token: result_message  # if success, result_message will be "new password"
      }.to_json
    else
      # raise result_message
      render status: 200, json: {
          status: "fail",
          code: result_code,
          message: result_message # if failed, result_message will be alert message
      }.to_json
    end
  end

  ## fire SOAP query to post the order
  def order_entry_param
    soap_header = generate_header(METHOD_ORDER_URL[LIVE] + 'orderEntryParam', SVC_ORDER_URL[LIVE])

    # create a client for the service
    client = get_soap_client(WSDL_ORDER_URL[LIVE], soap_header)

    data = {
      "TransCode" => params[:trans_code].try(:upcase), #NEW/MOD/CXL, Order : New/Modification/Cancellation
      "TransNo" => generate_trans_no(''), #trans_no is a unique number sent with every transaction creation request sent to BSE
      "OrderId" => params[:order_id], #BSE unique order number, for new order this field will be blank and in case of  modification and  cancellation the order  number has to be given
      "UserID" => params[:user_id],
      "MemberId" => params[:member_id],#Member code as given by BSE
      "ClientCode" => params[:client_code],
      "SchemeCd" => params[:scheme_code],#BSE scheme code
      "BuySell" => params[:buy_sell].try(:upcase), #P/R Type of transaction i.e.Purchase or Redemption
      "BuySellType" => params[:buy_sell_type].try(:upcase), #Buy/Sell type i.e. fresh or additional. FRESH/ADDITIONAL
      "DPTxn" => params[:dptxn].try(:upcase), #C/N/P, CDSL/NSDL/PHYSICAL
      "OrderVal" => params[:all_redeem].try(:downcase) == 'y' ? '': params[:amount], # Purchase/Redemption amount(redemption amount only in case of physical redemption)
      "Qty" => params[:all_redeem].try(:downcase) == 'y' ? '': params[:amount], # Redemption quantity
      "AllRedeem" => params[:all_redeem].try(:upcase), # All units flag, If this Flag is "Y" then units and amount column should be blank
      "FolioNo" => params[:folio_no],#Incase demat transaction this field will be blank and mandatory in case of physical redemption and purchase+additional
      "Remarks" => params[:remarks] || '',
      "KYCStatus" => params[:kyc_status].try(:upcase), # Y/N, KYC status of client
      "RefNo" =>'', #Internal reference number
      "SubBrCode" => params[:sub_br_code],# Sub Broker code
      "SubbroCode" => params[:sub_br_code],# Sub Broker code
      "SubberCode" => params[:sub_br_code],# Sub Broker code
      "SubBroCode" => params[:sub_br_code],# Sub Broker code
      "EUIN" => params[:euin], # EUIN number
      "EUINVal" => params[:euin_val],
      "MinRedeem" => params[:min_redeem].try(:upcase), #Y/N,  Minimum redemption flag
      "DPC" => params[:dpc].try(:upcase), #Y/N, DPC flag for purchase transactions
      "IPAdd" =>'',
      "Password" => params[:password],
      "PassKey" => params[:pass_key],
      "Param1" => params[:param_1],
      "Param2" => params[:param_2],
      "Param3" => params[:param_3]
    }

    response = call_soap_client(client, 'order_entry_param', data)
    hash = response.hash
    result_string = hash['envelope']['body']['order_entry_param_response']['order_entry_param_result']

    result = result_string.split('|')

    # Respond converted json response
    if result.last.to_i == 0
      render status: 200, json: {
          status: "success",
          transaction_code: result[0],
          unique_reference_number: result[1],
          order_number: result[2],
          user_id: result[3],
          member_id: result[4],
          client_code: result[5],
          bse_remarks: result[6],
          success_flag: result.last
      }.to_json
    else
      # raise result_message
      render status: 200, json: {
          status: "fail",
          success_flag: result.last,
          bse_remarks: result[6] # if failed, result_message will be alert message
      }.to_json
    end
  end

  ## fire SOAP query to post the SIP order
  def sip_order_entry_param
    soap_header = generate_header(METHOD_ORDER_URL[LIVE] + 'sipOrderEntryParam', SVC_ORDER_URL[LIVE])

    # create a client for the service
    client = get_soap_client(WSDL_ORDER_URL[LIVE], soap_header)

    #Must be calculated
    # UniqueRefNo
    # SchemeCode
    # FirstOrderFlag
    #
    data = {
        "TransactionCode" => params[:transaction_code].try(:upcase), #NEW/CXL, Order : New/Cancellation
        "UniqueRefNo" => generate_trans_no(''), #trans_no is a unique number sent with every transaction creation request sent to BSE
        "SchemeCode" => SecureRandom.hex,#BSE scheme code
        "MemberCode" => params[:member_id],#Member code as given by BSE
        "ClientCode" => params[:client_code],
        "UserID" => params[:user_id],
        "InternalRefNo" =>'', #Internal reference number
        "TransMode" => params[:trans_mode].try(:upcase),# D/P, demat or physica
        "DpTxnMode" => params[:dptxn].try(:upcase), #C/N/P, CDSL/NSDL/PHYSICAL
        "StartDate" => params[:start_date], #start time of the sip, DD/MM/YYYY
        "FrequencyType" => params[:frequency_type].try(:upcase), #type of requency , MONTHLY/QUARTERLY/WEEKLY
        "FrequencyAllowed" => params[:frequency_allowed], # roling frequency, 1
        "InstallmentAmount" => params[:installment_amount],#installment amount
        "NoOfInstallment" => params[:no_of_installment],
        "Remarks" => params[:remarks] || '',
        "FolioNo" => '', #Incase demat transaction this field will be blank and mandatory in case of physical redemption and purchase+additional
        "FirstOrderFlag" => "Y", #Must be calculated with database
        "SubBrCode" => params[:sub_br_code],# Sub Broker code
        "SubbroCode" => params[:sub_br_code],# Sub Broker code
        "SubberCode" => params[:sub_br_code],# Sub Broker code
        "SubBroCode" => params[:sub_br_code],# Sub Broker code
        "EUIN" => params[:euin], # EUIN number
        "EUINVal" => params[:euin_val],
        "DPC" => params[:dpc].try(:upcase), #Y/N, DPC flag for purchase transactions
        "RegId" => '',#SIP reg number. In case of new registration this will be blank
        "IPAdd" => params['ip_add'],
        "Password" => params[:password],
        "PassKey" => params[:pass_key],
        "Param1" => params[:param_1],
        "Param2" => params[:param_2],
        "Param3" => params[:param_3]
    }

    response = call_soap_client(client, 'sip_order_entry_param', data)
    hash = response.hash
    result_string = hash['envelope']['body']['sip_order_entry_param_response']['sip_order_entry_param_result']

    result = result_string.split('|')

    # Respond converted json response
    if result.last.to_i == 0
      render status: 200, json: {
          status: "success",
          transaction_code: result[0],
          unique_reference_number: result[1],
          member_id: result[2],
          client_code: result[3],
          user_id: result[4],
          sip_reg_id: result[5], #in case new SIP, BSE XSIP registration will be populated.
          bse_remarks: result[6],
          success_flag: result.last
      }.to_json
    else
      # raise result_message
      render status: 200, json: {
          status: "fail",
          success_flag: result.last,
          bse_remarks: result[6] # if failed, result_message will be alert message
      }.to_json
    end
  end

  ## fire SOAP query to post the XSIP order
  def xsip_order_entry_param
    soap_header = generate_header(METHOD_ORDER_URL[LIVE] + 'xsipOrderEntryParam', SVC_ORDER_URL[LIVE])

    # create a client for the service
    client = get_soap_client(WSDL_ORDER_URL[LIVE], soap_header)

    #Must be calculated
    # UniqueRefNo
    # SchemeCode
    # FirstOrderFlag
    #
    data = {
        "TransactionCode" => params[:transaction_code].try(:upcase), #NEW/CXL, Order : New/Cancellation
        "UniqueRefNo" => generate_trans_no(''), #trans_no is a unique number sent with every transaction creation request sent to BSE
        "SchemeCode" => SecureRandom.hex,#BSE scheme code
        "MemberCode" => params[:member_id],#Member code as given by BSE
        "ClientCode" => params[:client_code],
        "UserId" => params[:user_id],
        "InternalRefNo" =>'', #Internal reference number
        "TransMode" => params[:trans_mode].try(:upcase),# D/P, demat or physica
        "DpTxnMode" => params[:dptxn].try(:upcase), #C/N/P, CDSL/NSDL/PHYSICAL
        "StartDate" => params[:start_date], #start time of the sip, DD/MM/YYYY
        "FrequencyType" => params[:frequency_type].try(:upcase), #type of requency , MONTHLY/QUARTERLY/WEEKLY
        "FrequencyAllowed" => params[:frequency_allowed], # roling frequency, 1
        "InstallmentAmount" => params[:installment_amount],#installment amount
        "NoOfInstallment" => params[:no_of_installment],
        "Remarks" => params[:remarks] || '',
        "FolioNo" => '', #Incase demat transaction this field will be blank and mandatory in case of physical redemption and purchase+additional
        "FirstOrderFlag" => "Y", #Must be calculated with database
        "Brokerage" => params[:brokerage], #Money
        "MandateID" => params[:mandate_id],#Int, BSE mandate ID for XSIP Orders
        "SubBrCode" => params[:sub_br_code],# Sub Broker code
        "SubbroCode" => params[:sub_br_code],# Sub Broker code
        "SubberCode" => params[:sub_br_code],# Sub Broker code
        "SubBroCode" => params[:sub_br_code],# Sub Broker code
        "Euin" => params[:euin], # EUIN number
        "EuinVal" => params[:euin_val],
        "DPC" => params[:dpc].try(:upcase), #Y/N, DPC flag for purchase transactions
        "XsipRegId" => params[:xsip_regid],#Int, SIP reg number. In case of new registration this will be blank
        "IPAdd" => params['ip_add'],
        "Password" => params[:password],
        "PassKey" => params[:pass_key],
        "Param1" => params[:param_1],
        "Param2" => params[:param_2],
        "Param3" => params[:param_3]
    }

    response = call_soap_client(client, 'xsip_order_entry_param', data)
    hash = response.hash
    result_string = hash['envelope']['body']['xsip_order_entry_param_response']['xsip_order_entry_param_result']

    result = result_string.split('|')

    # Respond converted json response
    if result.last.to_i == 0
      render status: 200, json: {
          status: "success",
          transaction_code: result[0],
          unique_reference_number: result[1],
          member_id: result[2],
          client_code: result[3],
          user_id: result[4],
          xsip_reg_id: result[5], #in case new SIP, BSE XSIP registration will be populated.
          bse_remarks: result[6],
          success_flag: result.last
      }.to_json
    else
      # raise result_message
      render status: 200, json: {
          status: "fail",
          success_flag: result.last,
          bse_remarks: result[6] # if failed, result_message will be alert message
      }.to_json
    end
  end

  ## fire SOAP query to post the spread order
  def spread_order_entry_param
    soap_header = generate_header(METHOD_ORDER_URL[LIVE] + 'spreadOrderEntryParam', SVC_ORDER_URL[LIVE])

    # create a client for the service
    client = get_soap_client(WSDL_ORDER_URL[LIVE], soap_header)

    data = {
        "TransactionCode" => params[:trans_code].try(:upcase), #NEW/MOD/CXL, Order : New/Modification/Cancellation
        "UniqueRefNo" => generate_trans_no(''), #trans_no is a unique number sent with every transaction creation request sent to BSE
        "OrderID" => params[:order_id], #BSE unique order number, for new order this field will be blank and in case of  modification and  cancellation the order  number has to be given
        "UserID" => params[:user_id],
        "MemberId" => params[:member_id],#Member code as given by BSE
        "ClientCode" => params[:client_code],
        "SchemeCode" => params[:scheme_code],#BSE scheme code
        "BuySell" => params[:buy_sell].try(:upcase), #P/R Type of transaction i.e.Purchase or Redemption
        "BuySellType" => params[:buy_sell_type].try(:upcase), #Buy/Sell type i.e. fresh or additional. FRESH/ADDITIONAL
        "DPTxn" => params[:dptxn].try(:upcase), #C/N/P, CDSL/NSDL/PHYSICAL
        "OrderValue" => params[:order_value], # Purchase/Redemption amount
        "RedemptionAmt" => params[:redeem_amount], # Redemption quantity
        "AllUnitFlag" => params[:all_units_flag].try(:upcase), # All units flag, If this Flag is "Y" then units and amount column should be blank
        "RedeemDate" => params[:redeem_date], #redeemtion time of the sip, DD/MM/YYYY
        "FolioNo" => params[:folio_no],#Incase demat transaction this field will be blank and mandatory in case of physical redemption and purchase+additional
        "Remarks" => params[:remarks] || '',
        "KYCStatus" => params[:kyc_status].try(:upcase), # Y/N, KYC status of client
        "RefNo" =>'', #Internal reference number
        "SubBrCode" => params[:sub_br_code],# Sub Broker code
        "SubbroCode" => params[:sub_br_code],# Sub Broker code
        "SubberCode" => params[:sub_br_code],# Sub Broker code
        "SubBroCode" => params[:sub_br_code],# Sub Broker code
        "EUIN" => params[:euin], # EUIN number
        "EUINVal" => params[:euin_val], # y/n
        "MinRedeem" => params[:min_redeem].try(:upcase), #Y/N,  Minimum redemption flag
        "DPC" => params[:dpc].try(:upcase), #Y/N, DPC flag for purchase transactions
        "IPAddress" => params[:ip_address] || '',
        "Password" => params[:password],
        "PassKey" => params[:pass_key],
        "Param1" => params[:param_1],
        "Param2" => params[:param_2],
        "Param3" => params[:param_3]
    }

    response = call_soap_client(client, 'spread_order_entry_param', data)
    hash = response.hash
    result_string = hash['envelope']['body']['spread_order_entry_param_response']['spread_order_entry_param_result']

    result = result_string.split('|')

    # Respond converted json response
    if result.last.to_i == 0
      render status: 200, json: {
          status: "success",
          transaction_code: result[0],
          unique_reference_number: result[1],
          order_id: result[2],
          user_id: result[3],
          member_id: result[4],
          client_code: result[5],
          bse_remarks: result[6],
          success_flag: result.last
      }.to_json
    else
      # raise result_message
      render status: 200, json: {
          status: "fail",
          success_flag: result.last,
          bse_remarks: result[6] # if failed, result_message will be alert message
      }.to_json
    end
  end

  ## fire SOAP query to post the switch order
  def switch_order_entry_param
    soap_header = generate_header(METHOD_ORDER_URL[LIVE] + 'switchOrderEntryParam', SVC_ORDER_URL[LIVE])

    # create a client for the service
    client = get_soap_client(WSDL_ORDER_URL[LIVE], soap_header)

    data = {
        "TransCode" => params[:trans_code].try(:upcase), #NEW/MOD/CXL, Order : New/Modification/Cancellation
        "TransNo" => generate_trans_no(''), #trans_no is a unique number sent with every transaction creation request sent to BSE
        "OrderId" => params[:order_id], #BSE unique order number, for new order this field will be blank and in case of  modification and  cancellation the order  number has to be given
        "UserId" => params[:user_id],
        "MemberId" => params[:member_id],#Member code as given by BSE
        "ClientCode" => params[:client_code],
        "FromSchemeCd" => params[:from_scheme_code],#BSE scheme code
        "ToSchemeCd" => params[:to_scheme_code],#BSE scheme code
        "BuySell" => params[:buy_sell].try(:upcase), #P/R Type of transaction i.e.Purchase or Redemption
        "BuySellType" => params[:buy_sell_type].try(:upcase), #Buy/Sell type i.e. fresh or additional. FRESH/ADDITIONAL
        "DPTxn" => params[:dptxn].try(:upcase), #C/N/P, CDSL/NSDL/PHYSICAL
        "OrderVal" => params[:switch_amount], # Money, Switch amount
        "SwitchUnits" => params[:switch_units], # Money, Switch units
        "AllUnitsFlag" => params[:all_units_flag].try(:upcase), # All units flag, If this Flag is "Y" then units and amount column should be blank
        "FolioNo" => '',#Incase demat transaction this field will be blank and mandatory in case of physical redemption and purchase+additional
        "Remarks" => params[:remarks] || '',
        "KYCStatus" => params[:kyc_status].try(:upcase), # Y/N, KYC status of client
        "SubBrCode" => params[:sub_br_code],# Sub Broker code
        "SubbroCode" => params[:sub_br_code],# Sub Broker code
        "SubberCode" => params[:sub_br_code],# Sub Broker code
        "SubBroCode" => params[:sub_br_code],# Sub Broker code
        "EUIN" => params[:euin], # EUIN number
        "EUINVal" => params[:euin_val],
        "MinRedeem" => params[:min_redeem].try(:upcase), #Y/N,  Minimum redemption flag
        "IPAdd" =>'',
        "Password" => params[:password],
        "PassKey" => params[:pass_key],
        "Param1" => params[:param_1],
        "Param2" => params[:param_2],
        "Param3" => params[:param_3]
    }

    response = call_soap_client(client, 'switch_order_entry_param', data)
    hash = response.hash
    result_string = hash['envelope']['body']['switch_order_entry_param_response']['switch_order_entry_param_result']

    result = result_string.split('|')

    # Respond converted json response
    if result.last.to_i == 0
      render status: 200, json: {
          status: "success",
          transaction_code: result[0],
          unique_reference_number: result[1],
          order_id: result[2],
          user_id: result[3],
          member_id: result[4],
          client_code: result[5],
          bse_remarks: result[6],
          success_flag: result.last
      }.to_json
    else
      # raise result_message
      render status: 200, json: {
          status: "fail",
          success_flag: result.last,
          bse_remarks: result[6] # if failed, result_message will be alert message
      }.to_json
    end
  end
end
