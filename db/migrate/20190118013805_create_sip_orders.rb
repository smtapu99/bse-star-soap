class CreateSipOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :sip_orders do |t|

      t.string :trans_code, default: 'NEW', null: false #NEW/CXL, New SIP or Cancellation of SIP
      t.string :trans_no, default: nil, null: false #trans_no is a unique number sent with every transaction creation request sent to BSE
      t.string :scheme_code, null: false #BSE scheme code
      t.string :member_id, null: false #Member code as given by BSE
      t.string :client_code, null: false #Client Code
      t.integer :user_id, null: false #User ID as given by BSE
      t.string :internal_ref_no, null: false #internal reference number
      t.string :trans_mode, null: false #D/P demat or physical
      t.string :dp_transaction_mode, null: false #C/N/P
      t.timestamp :start_date, null: true
      t.string :frequency_type, default: 'MONTHLY', null: false # type of frequency
      t.integer :frequency_allowed, default: 1, null:false # roling frequency
      t.integer :installment_amount, null: false #installment amount
      t.integer :no_of_installment, null: false # number of installment
      t.string :remarks, default: '', null: true
      t.string :folio_no, default: nil, null: true #Incase demat transaction this field will be blank and mandatory in case of physical SIP
      t.string :first_order_flag, default: 'N', null: false # Y/N, first order today flag
      t.string :sub_br_code, default: nil, null: true # Sub Broker code
      t.string :euin, null: false # EUIN number
      t.string :euin_delcaration_flag, default: 'N' # Y/N, EUIN declaration flag
      t.string :dpc, default: 'Y', null: false #Y/N, DPC flag for purchase transactions
      t.integer :regid #SIP reg number.Incase of new registration this will be blank
      t.string :ip_add, null: true
      t.string :param_1, null: true #(Sub Broker ARN), Filler 1 Will Be Used As Sub Broker ARN Code
      t.string :param_2, null: true #(End Date), End date of daily SIP, Mandatory only in case of daily SIP only for MFI/RFI
      t.string :param_3, null: true

      t.timestamps
    end
  end
end
