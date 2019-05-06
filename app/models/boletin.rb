class Boletin < ActiveRecord::Base

  validates_presence_of :titulo
  validates_presence_of :fecha
  has_attached_file :documento, :styles => {:pdf_thumbnail => ["", :jpg]},
                    :url => "/assets/portadas/:id_:basename.:extension",
                    :path => ":rails_root/public/assets/boletines/:style/:id_:basename.:extension",
                    :default_url => "/vacio.png" 

  validates_attachment_content_type :foto, :content_type => ['image/jpeg', 'image/png', 'image/jpg']
  validates_attachment_presence :documento
end
