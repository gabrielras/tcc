class CreateCredentialEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :credential_events, id: :uuid do |t|
      t.references :event, null: false, foreign_key: true, type: :uuid
      t.references :credential, foreign_key: true, type: :uuid

      t.string :method_type
      t.string :name
      t.string :author
      t.jsonb :metadata, default: {}

      t.timestamps
    end
  end
end
