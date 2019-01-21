# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_01_21_080647) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "sip_orders", force: :cascade do |t|
    t.string "trans_code", default: "NEW", null: false
    t.string "trans_no", null: false
    t.string "scheme_code", null: false
    t.string "member_id", null: false
    t.string "client_code", null: false
    t.integer "user_id", null: false
    t.string "internal_ref_no", null: false
    t.string "trans_mode", null: false
    t.string "dp_transaction_mode", null: false
    t.datetime "start_date"
    t.string "frequency_type", default: "MONTHLY", null: false
    t.integer "frequency_allowed", default: 1, null: false
    t.integer "installment_amount", null: false
    t.integer "no_of_installment", null: false
    t.string "remarks", default: ""
    t.string "folio_no"
    t.string "first_order_flag", default: "N", null: false
    t.string "sub_br_code"
    t.string "euin", null: false
    t.string "euin_delcaration_flag", default: "N"
    t.string "dpc", default: "Y", null: false
    t.integer "regid"
    t.string "ip_add"
    t.string "param_1"
    t.string "param_2"
    t.string "param_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spreader_orders", force: :cascade do |t|
    t.string "trans_code", default: "NEW", null: false
    t.string "trans_no", null: false
    t.integer "order_id"
    t.integer "user_id", null: false
    t.string "member_id", null: false
    t.string "client_code", null: false
    t.string "scheme_code", null: false
    t.string "buy_sell", default: "P", null: false
    t.string "buy_sell_type", default: "FRESH", null: false
    t.string "dptxn", default: "C", null: false
    t.string "purchase_amount"
    t.string "redeemption_amount"
    t.string "all_units_flag", default: "N", null: false
    t.datetime "redeem_date", null: false
    t.string "folio_no"
    t.string "remarks"
    t.string "kyc_status", default: "Y", null: false
    t.string "ref_no"
    t.string "sub_br_code"
    t.string "euin", null: false
    t.string "euin_flag", default: "Y", null: false
    t.string "min_redeem", default: "Y", null: false
    t.string "dpc", default: "Y", null: false
    t.string "ip_add"
    t.string "param_1"
    t.string "param_2"
    t.string "param_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "trans_code", default: "NEW", null: false
    t.string "trans_no", null: false
    t.integer "order_id"
    t.integer "user_id", null: false
    t.string "member_id", null: false
    t.string "client_code", null: false
    t.string "scheme_code", null: false
    t.string "buy_sell", default: "P", null: false
    t.string "buy_sell_type", default: "FRESH", null: false
    t.string "dptxn", default: "C", null: false
    t.decimal "amount", precision: 6, scale: 4
    t.decimal "qty", precision: 6, scale: 4
    t.string "all_redeem", default: "N", null: false
    t.string "folio_no"
    t.string "remarks"
    t.string "kyc_status", default: "Y", null: false
    t.string "ref_no"
    t.string "sub_br_code"
    t.string "euin", null: false
    t.string "euin_flag", default: "Y", null: false
    t.string "min_redeem", default: "Y", null: false
    t.string "dpc", default: "Y", null: false
    t.string "ip_add"
    t.string "password", null: false
    t.string "pass_key", null: false
    t.string "param_1"
    t.string "param_2"
    t.string "param_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "xsip_orders", force: :cascade do |t|
    t.string "trans_code", default: "NEW", null: false
    t.string "trans_no", null: false
    t.string "scheme_code", null: false
    t.string "member_id", null: false
    t.string "client_code", null: false
    t.integer "user_id", null: false
    t.string "internal_ref_no", null: false
    t.string "trans_mode", null: false
    t.string "dp_transaction_mode", null: false
    t.datetime "start_date"
    t.string "frequency_type", default: "MONTHLY", null: false
    t.integer "frequency_allowed", default: 1, null: false
    t.integer "installment_amount", null: false
    t.integer "no_of_installment", null: false
    t.string "remarks", default: ""
    t.string "folio_no"
    t.string "first_order_flag", default: "N", null: false
    t.string "brokerage"
    t.integer "mandate_id", null: false
    t.string "sub_br_code"
    t.string "euin", null: false
    t.string "euin_delcaration_flag", default: "N", null: false
    t.integer "xsip_regid"
    t.string "ip_add"
    t.string "param_1"
    t.string "param_2"
    t.string "param_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
