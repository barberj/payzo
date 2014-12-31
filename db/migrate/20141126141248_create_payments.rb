class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :message
      t.string :name
      t.string :email
      t.float :amount
      t.references :user, index: true

      t.timestamps
    end
  end
end
