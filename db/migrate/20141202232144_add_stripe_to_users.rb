class AddStripeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :stripe_uid, :string
    add_column :users, :stripe_auth_token, :string
  end
end
