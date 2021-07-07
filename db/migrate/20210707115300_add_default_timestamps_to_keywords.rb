class AddDefaultTimestampsToKeywords < ActiveRecord::Migration[6.1]
  def up
    execute("ALTER TABLE keywords ALTER COLUMN created_at SET DEFAULT CURRENT_TIMESTAMP;")
    execute("ALTER TABLE keywords ALTER COLUMN updated_at SET DEFAULT CURRENT_TIMESTAMP;")
  end
  def down
    execute("ALTER TABLE keywords ALTER COLUMN created_at SET DEFAULT null;")
    execute("ALTER TABLE keywords ALTER COLUMN updated_at SET DEFAULT null;")
  end
end
