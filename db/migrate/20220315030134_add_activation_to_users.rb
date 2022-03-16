class AddActivationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :activation_digest, :string
     # activated属性のデフォルトの論理値をfalseに指定
    add_column :users, :activated, :boolean, default: false
    add_column :users, :activated_at, :datetime
  end
end
