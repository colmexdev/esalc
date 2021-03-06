class CreatePublicacion < ActiveRecord::Migration
  def change
    create_table :publicacions do |t|
      t.text :autores, null: false
      t.text :titulo, null: false
      t.text :centro, null: false
      t.text :editorial
      t.text :lugar
      t.text :traduccion
      t.text :edicion
      t.integer :anio
      t.text :tematica
      t.text :link, null: false
      t.text :link_vid
    end
  end
end
