class CreateDirectorio < ActiveRecord::Migration
  def change
    create_table :directorios do |t|
      t.text :nombre, null: false
      t.text :centro, null: false
      t.text :temas, null: false
      t.text :correo
      t.text :sitio
    end
  end
end
