module ApplicationHelper

  include BseSettingsHelper

  def downcase_response_tag
    lambda { |key| key.snakecase.downcase }
  end

  def generate_header(action, to)
    method_url = action
    svc_url = to

    {
        # "csk:Action" => method_url,
        "csk:To" => svc_url,
        "csk:Action" => method_url,
        attributes!: {
            "csk:Action" => {"xmlns:csk" => "http://www.w3.org/2005/08/addressing"},
            "csk:To" => {"xmlns:csk" => "http://www.w3.org/2005/08/addressing"}
        }
    }
  end

  def get_order_entry_namespaces
    namespaces = [
        {
            "xmlns:soap" =>  "http://www.w3.org/2003/05/soap-envelope",
            "xmlns:bse" => "http://bsestarmf.in/"
        },
        {
            "xmlns:soap" =>  "http://www.w3.org/2003/05/soap-envelope",
            "xmlns:bse" => "http://bsestarmf.in/"
        }
    ]
    namespaces[LIVE]
  end

  def get_mfapi_namespaces
    namespaces = [
        {
            "xmlns:soap" =>  "http://www.w3.org/2003/05/soap-envelope",
            "xmlns:bse" => "http://bsestarmfdemo.bseindia.com/2016/01/",
        },
        {
            "xmlns:soap" =>  "http://www.w3.org/2003/05/soap-envelope",
            "xmlns:bse" => "http://www.bsestarmf.in/2016/01/"
        }
    ]
    namespaces[LIVE]
  end

  def get_soap_client(wsdl, soap_header, namespaces)
    # create a client for the service
    Savon.client(
        wsdl: wsdl,
        soap_header: soap_header,
        pretty_print_xml: true,
        namespace_identifier: 'bse',
        convert_request_keys_to: 'camelcase',  # or one of [:lower_camelcase, :upcase, :none]
        env_namespace: 'soap',
        namespaces: namespaces,
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
