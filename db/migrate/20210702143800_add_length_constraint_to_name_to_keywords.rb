class AddLengthConstraintToNameToKeywords < ActiveRecord::Migration[6.1]
  def change
    add_check_constraint :keywords, 'char_length(name) <= 255', name: 'char_length_name'

    execute("ALTER TABLE keywords ALTER COLUMN created_at SET DEFAULT CURRENT_TIMESTAMP")
    execute("ALTER TABLE keywords ALTER COLUMN updated_at SET DEFAULT CURRENT_TIMESTAMP")
  end
end
