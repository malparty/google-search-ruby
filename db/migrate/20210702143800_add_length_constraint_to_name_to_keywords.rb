class AddLengthConstraintToNameToKeywords < ActiveRecord::Migration[6.1]
  def change
    add_check_constraint :keywords, 'char_length(name) <= 255', name: 'char_length_name'
  end
end
