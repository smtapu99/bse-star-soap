class GetPasswordController < ApplicationController
  require 'uri'
  require 'net/http'
  require 'json'
  require 'active_support/core_ext'

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