class AddBecaToDirectorios < ActiveRecord::Migration
  def change
    add_column :directorios, :beca, :text
  end
end
