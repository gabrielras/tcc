class CreateEventMetadatas < ActiveRecord::Migration[7.0]
  def change
    create_table :event_metadatas, id: :uuid do |t|
      t.references :event, null: false, foreign_key: true, type: :uuid

      t.references :credential, foreign_key: true, type: :uuid
      t.references :credential_event, foreign_key: true, type: :uuid

      t.jsonb :metadata
      t.integer :estimated_cost
 
      t.timestamps
    end
  end
end
