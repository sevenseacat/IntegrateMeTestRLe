class AddEntryCountToCompetitions < ActiveRecord::Migration
  def up
    add_column :competitions, :entries_count, :integer, default: 0

    Competition.reset_column_information

    Competition.find_each do |c|
      c.entries_count = c.entries.count
      c.save!
    end
  end

  def down
    remove_column :competitions, :entries_count
  end
end
