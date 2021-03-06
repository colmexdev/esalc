Rails.application.routes.draw do

  devise_for :admins, :controllers => { :registrations => "registrations", :sessions => "sessions"}
  resources :admins

  devise_scope :admin do
    get "/acceder" => "devise/sessions#new"
  end

  get 'panel/panel' => 'panel#panel', :as => :panel
  get 'panel/principal' => 'panel#principal', :as => :panel_princ
  get 'panel/index' => 'panel#index', :as => :panel_index
  get 'panel/generar' => 'panel#generar', :as => :panel_nuevo
  get 'panel/editar' => 'panel#editar', :as => :panel_editar
  post 'panel' => 'panel#crear'
  get 'panel/:id' => 'panel#mostrar', :as => :panel_mostrar
  delete 'panel/:id' => 'panel#eliminar', :as => :panel_eliminar
  put 'panel/editar' => 'panel#actualizar'
  patch 'panel/editar' => 'panel#actualizar'

  get '/' => 'principal#principal', :as => :principal
  get '/libros' => 'principal#libros', :as => :libros
  get '/directorio' => 'principal#directorio', :as => :directorio
  get '/acerca-de' => 'principal#acerca_de', :as => :acerca
  get '/equipo' => 'principal#equipo', :as => :equipo
  get '/contacto' => 'principal#contacto', :as => :contacto
  get '/videoteca' => 'principal#videoteca', :as => :videoteca
  get '/historia' => 'principal#historia', :as => :historia
  get '/lengua-y-literatura' => 'principal#lengua_literatura', :as => :lengua
  get '/politica-partidos-instituciones' => 'principal#partidos_politicos', :as => :politica
  get '/relaciones-internacionales' => 'principal#relaciones_internacionales', :as => :relaciones
  get '/sociedad-economia' => 'principal#sociedad_economia', :as => :sociedad
  get '/violencia-derechos-humanos' => 'principal#violencia', :as => :violencia
  get '/articulos' => 'principal#articulos', :as => :articulos
  get '/tesis' => 'principal#tesis', :as => :tesis
  get '/seminarios' => 'principal#seminarios', :as => :seminarios
  get '/eventos' => 'principal#eventos', :as => :eventos
  get '/boletines' => 'principal#boletines', :as => :boletines
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root to: 'principal#principal'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
