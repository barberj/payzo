class AddSecureIdToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :secure_id, :string
  end
end
