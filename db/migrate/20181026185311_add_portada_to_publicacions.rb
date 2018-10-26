class AddPortadaToPublicacions < ActiveRecord::Migration
  def change
    add_attachment :publicacions, :portada
  end
end
