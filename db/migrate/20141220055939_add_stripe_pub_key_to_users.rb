class AddStripePubKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_pub_key, :string
  end
end
