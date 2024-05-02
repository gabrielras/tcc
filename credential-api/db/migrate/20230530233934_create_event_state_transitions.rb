# frozen_string_literal: true

class CreateEventStateTransitions < ActiveRecord::Migration[6.1]
  def change
    create_table :event_state_transitions, id: :uuid do |t|
      t.references :event, null: false, foreign_key: { on_delete: :cascade, to_table: :events }, type: :uuid
      t.string :to_state, null: false
      t.jsonb :metadata, default: {}
      t.integer :sort_key, null: false
      t.boolean :most_recent, null: false

      t.timestamps
    end

    add_index(:event_state_transitions,
      %i[event_id sort_key],
      unique: true,
      name: 'index_event_state_transitions_parent_sort'
    )
    add_index(:event_state_transitions,
      %i[event_id most_recent],
      unique: true,
      where: 'most_recent',
      name: 'index_event_state_transitions_parent_most_recent'
    )
  end
end
