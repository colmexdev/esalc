class CreateBoletins < ActiveRecord::Migration
  def change
    create_table :boletins do |t|
      t.text :titulo
      t.date :fecha
      t.attachment :documento

      t.timestamps null: false
    end
  end
end
