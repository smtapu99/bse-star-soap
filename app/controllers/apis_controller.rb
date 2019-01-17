class ApisController < ApplicationController

  include TransactionHelper
  ################ SOAP FUNCTIONS to get/post data - called by MAIN FUNCTIONS

  ## fire SOAP query to get password for Order API endpoint
  ## used by create_transaction_bse() and cancel_transaction_bse()
  def get_password_response
    soap_header = generate_header('getPassword') # "xmlns:ns3" => "http://www.w3.org/2005/08/addressing"

    # create a client for the service
    client = get_soap_client(soap_header)

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
    soap_header = generate_header('orderEntryParam')

    # create a client for the service
    client = get_soap_client(soap_header)

    data = {
      "TransCode" => params[:trans_code].try(:upcase), #NEW/MOD/CXL, Order : New/Modification/Cancellation
      "TransNo" => generate_trans_no(''), #trans_no is a unique number sent with every transaction creation request sent to BSE
      "OrderId" => params[:order_id], #BSE unique order number, for new order this field will be blank and in case of  modification and  cancellation the order  number has to be given
      "UserID" => params[:user_id],
      "MemberId" => params[:member_id],#Member code as given by BSE
      "ClientCode" => params[:client_code],
      "SchemeCd" => SecureRandom.hex,#BSE scheme code
      "BuySell" => params[:buy_sell].try(:upcase), #P/R Type of transaction i.e.Purchase or Redemption
      "BuySellType" => params[:buy_sell_type].try(:upcase), #Buy/Sell type i.e. fresh or additional. FRESH/ADDITIONAL
      "DPTxn" => params[:dptxn].try(:upcase), #C/N/P, CDSL/NSDL/PHYSICAL
      "OrderVal" => params[:all_redeem].try(:downcase) == 'y' ? '': params[:amount], # Purchase/Redemption amount(redemption amount only incase of physical redemption)
      "Qty" => params[:all_redeem].try(:downcase) == 'y' ? '': params[:amount], # Redemption quantity
      "AllRedeem" => params[:all_redeem].try(:upcase), # All units flag, If this Flag is "Y" then units and amount column should be blank
      "FolioNo" => '',#Incase demat transaction this field will be blank and mandatory in case of physical redemption and purchase+additional
      "Remarks" => '',
      "KYCStatus" => params[:kyc_status].try(:upcase), # Y/N, KYC status of client
      "RefNo" =>'', #Internal reference number
      "SubBrCode" => params[:sub_br_code],# Sub Broker code
      "EUIN" => params[:euin], # EUIN number
      "EUINVal" => params[:euin_val],
      "MinRedeem" => params[:min_redeem].try(:upcase), #Y/N,  Minimum redemption flag
      "DPC" => params[:dpc].try(:upcase), #Y/N, DPC flag for purchase transactions
      "IPAdd" =>'',
      "Password" => params[:password],
      "PassKey" => params[:pass_key],
      "Parma1" => params[:param_1],
      "Parma2" => params[:param_2],
      "Parma3" => params[:param_3]
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
end
