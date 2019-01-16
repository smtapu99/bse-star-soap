class ApisController < ApplicationController

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
      result_message
      # render status: 200, json: {
      #     status: "success",
      #     response_code: result_code,
      #     auth_token: result_message  # if success, result_message will be "new password"
      # }.to_json
    else
      raise result_message
      # render status: 200, json: {
      #     status: "fail",
      #     code: result_code,
      #     message: result_message # if failed, result_message will be alert message
      # }.to_json
    end
  end

  ## fire SOAP query to post the order
  def order_entry_param
    soap_header = generate_header('orderEntryParam')

    # create a client for the service
    client = get_soap_client(soap_header)

    soap_actions = client.operations
    write_log('soap_actions', soap_actions.inspect)
    data = {
        "UserId" => params[:user_id],
        "Password" => params[:password],
        "PassKey" => params[:pass_key]
    }

    response = call_soap_client(client, 'order_entry_param', data)
    hash = response.hash
    result_string = hash['envelope']['body']['order_entry_param_response']['order_entry_param_result']

    result_code = result_string.split('|').first
    result_message = result_string.split('|').last

    # Respond converted json response
    if result_code.to_i == 100
      render status: 200, json: {
          status: "success",
          response_code: result_code,
          auth_token: result_message  # if success, result_message will be "new password"
      }.to_json
    else
      raise result_message
      render status: 200, json: {
          status: "fail",
          code: result_code,
          message: result_message # if failed, result_message will be alert message
      }.to_json
    end
  end
end
