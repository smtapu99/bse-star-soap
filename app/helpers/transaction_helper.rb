module TransactionHelper

  #Unique Ref no-  numeric, length must be short than 20, YYYYMMDD<usercode>000001
  def generate_trans_no(trans_type, user_id = 1, last_ref_no = 1)
    trans_no_header = "#{Time.now.strftime('%Y%m%d')}#{user_id.to_s}#{(last_ref_no.to_i + 1).to_s}"
  end
end
