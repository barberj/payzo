class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :url_handle
      t.string :company_name
      t.string :company_description
      t.string :avatar
      t.string :email

      t.timestamps
    end
  end
end
