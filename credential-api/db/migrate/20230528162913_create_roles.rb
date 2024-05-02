class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :institution, null: false, foreign_key: true, type: :uuid

      t.string :role_type

      t.timestamps
    end
  end
end
