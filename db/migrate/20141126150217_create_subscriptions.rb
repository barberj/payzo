class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :plan
      t.references :user, index: true

      t.timestamps
    end
  end
end
