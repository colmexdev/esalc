class Publicacion < ActiveRecord::Base
  self.table_name = "publicacions"

  has_attached_file :portada, :styles => {},
                    :url => "/assets/portadas/:id_:basename.:extension",
                    :path => ":rails_root/public/assets/portadas/:id_:basename.:extension",
                    :default_url => "/vacio.png"

  validates_attachment_content_type :foto, :content_type => ['image/jpeg', 'image/png', 'image/jpg']
end
