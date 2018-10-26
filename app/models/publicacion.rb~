class Publicacion < ActiveRecord::Base
  self.table_name = "publicacions"

  has_attached_file :foto, :styles => {},
                    :url => "/assets/portadas/:id_:basename.:extension",
                    :path => ":rails_root/public/assets/portadas/:id_:basename.:extension",
                    :default_url => "/vacio.png"
end
