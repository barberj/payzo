class RenameStipeOauthKeyInUsers < ActiveRecord::Migration
  def change
    rename_column :users, :stripe_auth_token, :stripe_access_token
  end
end
