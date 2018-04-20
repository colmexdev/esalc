class CreateMagazine < ActiveRecord::Migration
  def change
    create_table :magazines do |t|
      t.text :articulo, null: false
      t.text :autores, null: false
      t.text :volumen
      t.text :numero
      t.text :fecha
      t.text :tematica
      t.text :link, null: false
    end
  end
end
