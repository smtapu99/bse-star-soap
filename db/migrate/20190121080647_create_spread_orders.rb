class CreateSpreadOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :spreader_orders do |t|

      t.string :trans_code, default: 'NEW', null: false #NEW/CXL, Order : New/Modification/Cancellation
      t.string :trans_no, default: nil, null: false #Unique reference number from the member. Number can be incremental for each order(000001, 000002,....). The number will be reset the next day.
      t.integer :order_id, default: nil, null: true #BSE unique order number, for new order this field will be blank and in case of  modification and  cancellation the order  number has to be given
      t.integer :user_id, null: false #User ID which will be given by BSE
      t.string :member_id, null: false #Member code as given by BSE
      t.string :client_code, null: false #Client Code
      t.string :scheme_code, null: false #BSE scheme code
      t.string :buy_sell, default: 'P', null: false #P/R Type of transaction i.e.Purchase or Redemption
      t.string :buy_sell_type, default: 'FRESH', null: false #Buy/Sell type i.e. fresh or additional. FRESH/ADDITIONAL
      t.string :dptxn, default: 'C', null: false #C/N/P, CDSL/NSDL/PHYSICAL
      t.string :purchase_amount #Purchase amount
      t.string :redeemption_amount #Purchase amount
      t.string :all_redeem, default: 'N', null: false #Y/N, all units flag, If this Flag is "Y" then units and amount column should be blank
      t.timestamp :redeem_date, null: false # Redeem date DD/MM/YYYY
      t.string :folio_no, default: nil, null: true #Incase demat transaction this field will be blank and mandatory in case of physical redemption and purchase+additional
      t.string :remarks, default: nil, null: true
      t.string :kyc_status, default: 'Y', null: false # Y/N, KYC status of client
      t.string :ref_no, default: nil, null: true #Internal reference number
      t.string :sub_br_code, default: nil, null: true # Sub Broker code
      t.string :euin, null: false # EUIN number
      t.string :euin_flag, default: 'Y', null: false #Y/N, EUIN declaration
      t.string :min_redeem, default: 'Y', null: false #Y/N,  Minimum redemption flag
      t.string :dpc, default: 'Y', null: false #Y/N, DPC flag for purchase transactions
      t.string :ip_add, null: true
      t.string :param_1, null: true #(Sub Broker ARN), Filler 1 Will Be Used As Sub Broker ARN Code
      t.string :param_2, null: true
      t.string :param_3, null: true
      t.timestamps
    end
  end
end
