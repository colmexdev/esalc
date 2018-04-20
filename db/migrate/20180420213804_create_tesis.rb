class CreateTesis < ActiveRecord::Migration
  def change
    create_table :teses do |t|
      t.text :autores, null: false
      t.text :titulo, null: false
      t.text :asesores, null: false
      t.text :tematica
      t.integer :anio
      t.text :idioma
      t.text :link
      t.text :grado, null: false
      t.text :programa, null: false
      t.text :centro, null: false
    end
  end
end
