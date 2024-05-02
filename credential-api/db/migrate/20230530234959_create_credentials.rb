class CreateCredentials < ActiveRecord::Migration[7.0]
  def change
    create_table :credentials, id: :uuid do |t|
      t.references :institution, null: false, foreign_key: true, type: :uuid

      t.string :name
      t.string :author
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
