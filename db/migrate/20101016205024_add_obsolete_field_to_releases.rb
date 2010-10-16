class AddObsoleteFieldToReleases < ActiveRecord::Migration
  def self.up
    change_table :releases do |t|
      t.boolean :obsolete, :default => false
    end
  end

  def self.down
    change_table :releases do |t|
      t.remove :obsolete
    end
  end
end
