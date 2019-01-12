class GetPasswordController < ApplicationController
  require 'uri'
  require 'net/http'
  require 'json'
  require 'active_support/core_ext'
  ################ SOAP FUNCTIONS to get/post data - called by MAIN FUNCTIONS

  ## fire SOAP query to get password for Order API endpoint
  ## used by create_transaction_bse() and cancel_transaction_bse()
  def get_password_response
    soap_header = {
        "csk:Action" => "http://bsestarmf.in/MFOrderEntry/getPassword",
        "csk:To" => "http://www.bsestarmf.in/MFOrderEntry/MFOrder.svc",
        attributes!: {
            "csk:Action" => {"xmlns:csk" => "http://www.w3.org/2005/08/addressing"},
            "csk:To" => {"xmlns:csk" => "http://www.w3.org/2005/08/addressing"}}
    }
    # "xmlns:ns3" => "http://www.w3.org/2005/08/addressing"
    namespaces = {
        "xmlns:soap-env" =>  "http://www.w3.org/2003/05/soap-envelope",
        "xmlns:ns1" => "http://bsestarmf.in/",
    }
    downcase = lambda { |key| key.snakecase.downcase }
    # create a client for the service
    client = Savon.client(
                      wsdl: 'http://www.bsestarmf.in/MFOrderEntry/MFOrder.svc?singleWsdl',
                      soap_header: soap_header,
                      pretty_print_xml: true,
                      namespace_identifier: 'ns1',
                      convert_request_keys_to: 'camelcase',  # or one of [:lower_camelcase, :upcase, :none]
                      env_namespace: 'soap-env',
                      namespaces: namespaces,
                      strip_namespaces: true, #to strip any namespace identifiers from the response
                      convert_response_tags_to: downcase, #every XML tag and simply has to return the converted tag.
                      headers: {
                          'Content-Type' => 'application/soap+xml'
                      }

    )

    # data = {"UserId" => '2505901', "Password" => 'Finbridge@321', "PassKey" => '9958788281'}
    data = {"UserId" => params[:user_id], "Password" => params[:password], "PassKey" => params[:pass_key]}
    # soap_actions = client.operations

    begin
      response = client.call(:get_password, message: data)
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
        render status: 200, json: {
            status: "success",
            code: result_code,
            message: result_message  # if success, result_message will be "new password"
        }.to_json
      else
        render status: 200, json: {
            status: "fail",
            code: result_code,
            message: result_message # if failed, result_message will be alert message
        }.to_json
      end
    rescue Savon::SOAPFault => error
      fault_code = error.to_hash[:fault][:faultcode]
      raise fault_code
    end
  end

  def get_password_response0

    url = URI("http://www.bsestarmf.in/MFOrderEntry/MFOrder.svc?singleWsdl")

    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = 'application/soap+xml'
    request.body = '<soap-env:Envelope xmlns:ns1="http://bsestarmf.in/"
                      xmlns:soap-env="http://www.w3.org/2003/05/soap-envelope">
                      <soap-env:Header>
                        <ns3:Action xmlns:ns3="http://www.w3.org/2005/08/addressing">http://bsestarmf.in/MFOrderEntry/getPassword</ns3:Action>
                        <ns4:To xmlns:ns4="http://www.w3.org/2005/08/addressing">http://www.bsestarmf.in/MFOrderEntry/MFOrder.svc</ns4:To>
                      </soap-env:Header>
                      <soap-env:Body>
                        <ns1:getPassword>
                          <ns1:UserId>2505901</ns1:UserId>
                          <ns1:Password>Finbridge@321</ns1:Password>
                          <ns1:PassKey>9958788281</ns1:PassKey>
                        </ns1:getPassword>
                      </soap-env:Body>
                      </soap-env:Envelope>'

    response = http.request(request)
    converted = Hash.from_xml(response.body).to_json
    render status: 200, json: converted
    write_log('response', converted.inspect)
  end

end