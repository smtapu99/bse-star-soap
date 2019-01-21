class CreateXsipOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :xsip_orders do |t|

      t.string :trans_code, default: 'NEW', null: false #NEW/CXL, New XSIP or Cancellation of SIP
      t.string :trans_no, default: nil, null: false #Unique reference number from the member. Number can be incremental for each order(000001, 000002,....). The number will be reset the next day.
      t.string :scheme_code, null: false #BSE scheme code
      t.string :member_id, null: false #Member code as given by BSE
      t.string :client_code, null: false #Client Code
      t.integer :user_id, null: false #User ID as given by BSE
      t.string :internal_ref_no, null: false #internal reference number
      t.string :trans_mode, null: false #D/P demat or physical
      t.string :dp_transaction_mode, null: false #C/N/P, CDSL/NSDL/PHYSICAL
      t.timestamp :start_date, null: true
      t.string :frequency_type, default: 'MONTHLY', null: false # type of frequency
      t.integer :frequency_allowed, default: 1, null:false # roling frequency
      t.integer :installment_amount, null: false #installment amount
      t.integer :no_of_installment, null: false # number of installment
      t.string :remarks, default: '', null: true
      t.string :folio_no, default: nil, null: true #Incase demat transaction this field will be blank and mandatory in case of physical SIP
      t.string :first_order_flag, default: 'N', null: false # Y/N, first order today flag
      t.string :brokerage, null: true
      t.integer :mandate_id, null: false # Mandatory for XSIP Orders
      t.string :sub_br_code, default: nil, null: true # Sub Broker code
      t.string :euin, null: false # EUIN number
      t.string :euin_delcaration_flag, default: 'N', null: false # Y/N, EUIN declaration flag
      t.integer :xsip_regid #XSIP reg number.In case of new registration this will be blank
      t.string :ip_add, null: true
      t.string :param_1, null: true #(Sub Broker ARN), Filler 1 Will Be Used As Sub Broker ARN Code
      t.string :param_2, null: true #(ISIP Mandate ID), ISIP Mandate, Mandatory for ISIP Orders
      t.string :param_3, null: true
      t.timestamps
    end
  end
end
