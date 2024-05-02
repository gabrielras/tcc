class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events, id: :uuid do |t|
      t.references :institution, foreign_key: true, type: :uuid
      t.references :user, foreign_key: true, type: :uuid

      t.string :title
      t.jsonb :metadata

      t.string :state

      t.timestamps
    end
  end
end
