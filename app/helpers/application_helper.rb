module ApplicationHelper

  include BseSettingsHelper

  def downcase_response_tag
    lambda { |key| key.snakecase.downcase }
  end

  def generate_header(action, to = nil)
    method_url = METHOD_ORDER_URL[LIVE] + action
    svc_url = SVC_ORDER_URL[LIVE]

    {
        "csk:Action" => method_url,
        "csk:To" => svc_url,
        attributes!: {
            "csk:Action" => {"xmlns:csk" => "http://www.w3.org/2005/08/addressing"},
            "csk:To" => {"xmlns:csk" => "http://www.w3.org/2005/08/addressing"}}
    }
  end

  def get_namespaces
    {
        "xmlns:soap-env" =>  "http://www.w3.org/2003/05/soap-envelope",
        "xmlns:ns1" => "http://bsestarmf.in/",
    }
  end

  def get_soap_client(soap_header)
    # create a client for the service
    Savon.client(
        wsdl: 'http://www.bsestarmf.in/MFOrderEntry/MFOrder.svc?singleWsdl',
        soap_header: soap_header,
        pretty_print_xml: true,
        namespace_identifier: 'ns1',
        convert_request_keys_to: 'camelcase',  # or one of [:lower_camelcase, :upcase, :none]
        env_namespace: 'soap-env',
        namespaces: get_namespaces,
        strip_namespaces: true, #to strip any namespace identifiers from the response
        convert_response_tags_to: downcase_response_tag, #every XML tag and simply has to return the converted tag.
        headers: {
            'Content-Type' => 'application/soap+xml'
        }

    )
  end

  def call_soap_client(client, method, data)
    client.call(:"#{method}", message: data)
  end
end
