class AddSuccessToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :success, :boolean, default: false
  end
end
