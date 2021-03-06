class PanelController < ApplicationController
  before_action :authenticate_admin!
  before_action :select_set, only: [:principal, :index, :mostrar, :generar, :crear, :eliminar, :actualizar, :editar]
  before_action :get_object_fields, only: [:index, :crear, :actualizar, :eliminar, :mostrar]

  def principal
		grupos = @sets.map {|k,v| v[:model]}
    @groups = []
    grupos.each_with_index do |g,i|
      begin
        @groups << g.where("created_at >= ? OR updated_at >= ?", Date.today-30, Date.today-30).pluck(:nombre,:created_at,:updated_at).map {|x| {nombre: x[0], fecha_creacion: x[1].to_date, fecha_upd: x[2].to_date, tipo: @sets.keys[i].to_s}}
      rescue Exception => e
        #next
      end
      begin
        @groups << g.where("created_at >= ? OR updated_at >= ?", Date.today-30, Date.today-30).pluck(:titulo,:created_at,:updated_at).map {|x| {nombre: x[0], fecha_creacion: x[1].to_date, fecha_upd: x[2].to_date, tipo: @sets.keys[i].to_s}}
      rescue Exception => e
        #next
      end
      begin
        @groups << g.where("created_at >= ? OR updated_at >= ?", Date.today-30, Date.current-30).pluck(:cita,:created_at,:updated_at).map {|x| {nombre: x[0], fecha_creacion: x[1].to_date, fecha_upd: x[2].to_date, tipo: @sets.keys[i].to_s}}
      rescue Exception => e
        #next
      end
      begin
        @groups << g.where("created_at >= ? OR updated_at >= ?", Date.today-30, Date.current-30).pluck(:badge,:created_at,:updated_at).map {|x| {nombre: x[0], fecha_creacion: x[1].to_date, fecha_upd: x[2].to_date, tipo: @sets.keys[i].to_s}}
      rescue Exception => e
        #next
      end
    end
    @groups = @groups.reject{|g| g.empty?}.flatten
    respond_to do |format|
      format.js
      format.json {render json: {groups: @groups, last_time: (Date.current() - 30)}}
    end
  end

  def panel
  end

  def index
    if params[:keyword].present?
      query
      @query = @query + (params[:complement].present? ? (" and " + params[:complement]) : "")
    else
      @query = (params[:complement].present? ? params[:complement] : "")
    end
    @rpp = 10
		@m = @sets[params[:set].to_sym][:model]
    @mod = (@m.class.to_s != "Array" ? @m : @m[0])
    @count = @mod.where(@query.present? ? @query : "").count
    @set = @mod.where(@query.present? ? @query : "").order(updated_at: :desc).limit(@rpp).offset(params[:offset].to_i*@rpp)

    @pags = (@count == 0 ? 0 : ((@count / @rpp) + (@count % @rpp == 0 ? 0 : 1) ))
    respond_to do |format|
      format.js
      #format.json {render json: {filas: @set} }
    end
  end

  def mostrar
		@obj = @sets[params[:set].to_sym][:model].find(params[:id].to_i)
    respond_to do |format|
      format.js
    end
  end

  def generar
    @obj = @sets[params[:set].to_sym][:model].new
    respond_to do |format|
      format.js
    end
  end

  def crear
    @obj = @sets[params[:set].to_sym][:model].new(obj_params)
	  @sets[params[:set].to_sym][:trix].each do |t|
      @obj[t] = (@obj[t].nil? ? "" : @obj[t].gsub(/<br><\/div>/,"</div>").gsub(/<br>(<br>)+/,"<br>").gsub(/<br>/,"</p><p>").gsub(/<div>/,"<p>").gsub(/<\/div>/,"</p>"))
    end
    respond_to do |format|
      if @obj.save
#        if @sets[params[:set].to_sym][:model] == Sitio
#          i = 0
#          while i < obj_params[:num_parrafos].to_i
#            @pf = Parrafo.new({sitio_id: @obj.id, p_ind: i})
#            @pf.save
#            i = i + 1
#          end
#          i = 0
#          while i < obj_params[:num_fotos].to_i
#            @pf = Foto.new({sitio_id: @obj.id, f_ind: i})
#            @pf.save
#            i = i + 1
#          end
#          i = 0
#          while i < obj_params[:num_listing].to_i
#            @pf = Listing.new({sitio_id: @obj.id, ord_index: i})
#            @pf.save
#            i = i + 1
#          end
#        end
        format.js { render :mostrar, params: {set: params[:set], id: @obj.id}, notice: 'Objeto generado exitosamente.' }
      else
        format.js { render :generar }
        format.json { render json: @obj.errors, status: :unprocessable_entity }
      end
    end
  end

  def editar
    if @sets[params[:set].to_sym][:model].class.to_s != "Array"
      @obj = @sets[params[:set].to_sym][:model].find(params[:id])
			@sets[params[:set].to_sym][:trix].each do |t|
        @obj[t] = (@obj[t].nil? ? "" : @obj[t].gsub(/<p>/,"<div>").gsub(/<\/p>/,"</div>").gsub(/<\/div><div>/,"<br>"))
      end
    elsif params[:set] == "Contenido de sitios"
      @obj = Sitio.find(params[:id])
      @pars = Parrafo.where("sitio_id = ?",params[:id].to_i)
      @pics = Foto.where("sitio_id = ?",params[:id].to_i)
      @pars.each do |p|
        p.texto = (p.texto.nil? ? "" : p.texto.gsub(/<p>/,"<div>").gsub(/<\/p>/,"</div>").gsub(/<\/div><div>/,"<br>"))
        p.texto_ingles = (p.texto_ingles.nil? ? "" : p.texto_ingles.gsub(/<p>/,"<div>").gsub(/<\/p>/,"</div>").gsub(/<\/div><div>/,"<br>"))
      end
      @pics.each do |p|
        p.caption = (p.caption.nil? ? "" : p.caption.gsub(/<p>/,"<div>").gsub(/<\/p>/,"</div>").gsub(/<\/div><div>/,"<br>"))
        p.caption_ingles = (p.caption_ingles.nil? ? "" : p.caption_ingles.gsub(/<p>/,"<div>").gsub(/<\/p>/,"</div>").gsub(/<\/div><div>/,"<br>"))
      end
    end
  end

  def actualizar
    @obj = @sets[params[:set].to_sym][:model].find(params[:id])
    if params[:set] != "Contenido de sitios"
      @sets[params[:set].to_sym][:trix].each do |t|
        obj_params[t] = obj_params[t].gsub(/<br><\/div>/,"</div>").gsub(/<br>(<br>)+/,"<br>").gsub(/<br>/,"</p><p>").gsub(/<div>/,"<p>").gsub(/<\/div>/,"</p>")
      end
    end
    respond_to do |format|
      if params[:set] == "Contenido de sitios"
        if params[:pars].present?
          @llaves_pars = params[:pars].keys
          @vals_pars = params[:pars].values
          params[:pars].each_with_index do |p,i|
					  @vals_pars[i]["texto"] = (@vals_pars[i]["texto"].nil? ? (Parrafo.find(@llaves_pars[i].to_i).texto.nil? || Parrafo.find(@llaves_pars[i].to_i).texto == "" ? "" : Parrafo.find(@llaves_pars[i].to_i).texto) : @vals_pars[i]["texto"].gsub(/<br>/,"</p><p>").gsub(/<div>/,"<p>").gsub(/<\/div>/,"</p>"))
					  @vals_pars[i]["texto_ingles"] = (@vals_pars[i]["texto_ingles"].nil? ? (Parrafo.find(@llaves_pars[i].to_i).texto_ingles.nil? || Parrafo.find(@llaves_pars[i].to_i).texto_ingles == "" ? "" : Parrafo.find(@llaves_pars[i].to_i).texto_ingles) : @vals_pars[i]["texto_ingles"].gsub(/<br>/,"</p><p>").gsub(/<div>/,"<p>").gsub(/<\/div>/,"</p>"))
          Parrafo.find(@llaves_pars[i].to_i).update(par_params(ActionController::Parameters.new(@vals_pars[i])))
          end
        end
        if params[:pics].present?
          @llaves_pics = params[:pics].keys
          @vals_pics = params[:pics].values
          params[:pics].each_with_index do |p,i|
					  @vals_pics[i]["caption"] = (@vals_pics[i]["caption"].nil? ? (Foto.find(@llaves_pics[i].to_i).caption.nil? || Foto.find(@llaves_pics[i].to_i).caption == "" ? "" : Foto.find(@llaves_pics[i].to_i).caption) : @vals_pics[i]["caption"].gsub(/<br>/,"</p><p>").gsub(/<div>/,"<p>").gsub(/<\/div>/,"</p>"))
					  @vals_pics[i]["caption_ingles"] = (@vals_pics[i]["caption_ingles"].nil? ? (Foto.find(@llaves_pics[i].to_i).caption_ingles.nil? || Foto.find(@llaves_pics[i].to_i).caption_ingles == "" ? "" : Foto.find(@llaves_pics[i].to_i).caption_ingles) : @vals_pics[i]["caption_ingles"].gsub(/<br>/,"</p><p>").gsub(/<div>/,"<p>").gsub(/<\/div>/,"</p>"))
            Foto.find(@llaves_pics[i].to_i).update(pic_params(ActionController::Parameters.new(@vals_pics[i])))
          end
        end
        if params[:listings].present?
          @llaves_list = params[:listings].keys
          @vals_list = params[:listings].values
          params[:listings].each_with_index do |p,i|
            Listing.find(@llaves_list[i].to_i).update(list_params(ActionController::Parameters.new(@vals_list[i])))
          end
        end
        if params[:uri]
          format.html {redirect_to params[:uri]}
        else
          format.js { render :mostrar, params: {set: params[:set], id: params[:id]}, notice: 'Objeto generado exitosamente.' }
        end
      elsif @obj.update(obj_params)
#        if @sets[params[:set].to_sym][:model] == Sitio
#          @num_pars = Parrafo.where("sitio_id = ?", params[:id].to_i)
#          @num_fotos = Foto.where("sitio_id = ?", params[:id].to_i)
#          @num_listing = Listing.where("sitio_id = ?", params[:id].to_i)
#          if @num_pars.count < obj_params[:num_parrafos].to_i
#            k = 0
#            while k < obj_params[:num_parrafos].to_i
#              if Parrafo.where("sitio_id = ? and p_ind = ? ", params[:id].to_i, k).count == 0
#                @pf = Parrafo.new({sitio_id: params[:id].to_i, p_ind: k})
#                @pf.save
#              end
#              k = k + 1
#            end
#          else
#            while @num_pars.count > obj_params[:num_parrafos].to_i
#              @num_pars[-1].destroy
#            end
#          end
#
#          if @num_fotos.count < obj_params[:num_fotos].to_i
#            k = 0
#            while k < obj_params[:num_fotos].to_i
#              if Foto.where("sitio_id = ? and f_ind = ? ",params[:id].to_i, k).count == 0
#                @pf = Foto.new({sitio_id: params[:id].to_i, f_ind: k})
#                @pf.save
#              end
#              k = k + 1
#            end
#          else
#            while @num_fotos.count > obj_params[:num_fotos].to_i
#              @num_fotos[-1].destroy
#            end
#          end
#
#          if @num_listing.count < obj_params[:num_listing].to_i
#            k = 0
#            while k < obj_params[:num_listing].to_i
#              if Listing.where("sitio_id = ? and ord_index = ?",params[:id].to_i, k).count == 0
#                @pf = Listing.new({sitio_id: params[:id].to_i, ord_index: k})
#                @pf.save
#              end
#              k = k + 1
#            end
#          else
#            while @num_listing.count > obj_params[:num_listing].to_i
#              @num_listing[-1].destroy
#            end
#          end
#
#        end
        format.js { render :mostrar, params: {set: params[:set], id: @obj.id}, notice: 'Objeto generado exitosamente.' }
      else
        format.js { render :editar }
        format.json { render json: @obj.errors, status: :unprocessable_entity }
      end
    end
  end

  def eliminar
		@sets[params[:set].to_sym][:model].find(params[:id]).destroy
    if params[:set] == "Catálogo de sitios"
      Parrafo.where("sitio_id = ?", params[:id].to_i).destroy_all
      Foto.where("sitio_id = ?", params[:id].to_i).destroy_all
      Listing.where("sitio_id= ?",params[:id].to_i).destroy_all
    end
    @set = @sets[params[:set].to_sym][:model].order(updated_at: :desc).limit(@rpp).offset(0)
    @rpp = 10
    @count = @sets[params[:set].to_sym][:model].count
    @pags = (@count == 0 ? 0 : ((@count / @rpp) + (@count % @rpp == 0 ? 0 : 1) ))
		respond_to do |format|
      format.js { render :index, params: {set: params[:set]}, notice: 'Se ha eliminado el objeto exitosamente'}
		  format.json { head :no_content }
		end
  end

  private

  def query
    @query = "("
    keys = params[:keyword].split(/ +/).map {|k| " like '%" + k.downcase + "%'"}
    @fields.keys.each do |f|
      h = ""
      if ["anio"].include?(f.to_s)
        next
      end
      keys.each_with_index do |k,i|
        h =  h + f.to_s + k + (i == keys.size - 1 ? '' : ' AND ')
      end

      @query = @query + h + (f == @fields.keys[-1] ? ")" : " or ")
    end
  end

  def select_set
    @sets = {
      "Revistas": {
        model: Revista,
        fields: {articulo: "Título", autores: "Autor(es)", volumen: "Volumen", numero: "Número", fecha: "Fecha de publicación", tematica: "Temática(s)", link: "Liga", revista: "Revista", centro: "Centro de estudios"},
        imgs: {},
        trix: []
      }, "Tesis": {
        model: Tesis,
        fields: {autores: "Autor(es)", titulo: "Título", asesores: "Asesor(es)", tematica: "Temática(s)", anio: "Año", idioma: "Idioma", link: "Liga", grado: "Grado académico", programa: "Programa académico", centro: "Centro de Estudios"},
        imgs: {},
        trix: []
      }, "Publicaciones": {
        model: Publicacion,
        fields: {autores: "Autor(es)", titulo: "Título", centro: "Centro de Estudios", editorial: "Editorial", lugar: "Lugar de publicación", traduccion: "Traducido por", edicion: "Edición", anio: "Año", tematica: "Temática(s)", link: "Liga", link_vid: "Ligas de videos asociados"},
        imgs: {portada: "Portada"},
        trix: []
      }, "Personal del Directorio": {
        model: Directorio,
        fields: {nombre: "Nombre (Apellidos, Nombre(s))", beca: "Beca postdoctoral", centro: "Centro de Estudios", temas: "Temas de investigación", correo: "Correo electrónico", sitio: "Sitio web"},
        imgs: {},
        trix: []
      }, "Boletines": {
        model: Boletin,
        fields: {titulo: "Título", fecha: "Fecha de lanzamiento"},
        imgs: {documento: "Boletín"},
        trix: []
      }
    }
  end

  def get_object_fields
    @fields = (@sets[params[:set].to_sym][:fields].class.to_s != "Array" ? @sets[params[:set].to_sym][:fields] : @sets[params[:set].to_sym][:fields][0] )
    @imgs = (@sets[params[:set].to_sym][:imgs].class.to_s != "Array" ? @sets[params[:set].to_sym][:imgs] : @sets[params[:set].to_sym][:imgs][0])
  end

  def par_params(pars)
    pars.permit(:ref, :texto, :texto_ingles, :p_ind)
  end

  def pic_params(pics)
    pics.permit(:ref, :foto, :f_ind, :caption, :caption_ingles)
  end

  def list_params(lists)
    lists.permit(:ord_index, :list_id, :sitio_id)
  end

  def obj_params
    if params[:set] == "Revistas"
      params.require(:revista).permit(:articulo, :autores, :volumen, :numero, :fecha, :link, :revista, :centro, tematica:[])
    elsif params[:set] == "Tesis"
      params.require(:tesis).permit(:autores, :titulo, :asesores, :anio, :idioma, :link, :grado, :programa, :centro, tematica:[])
    elsif params[:set] == "Publicaciones"
      params.require(:publicacion).permit(:autores, :titulo, :centro, :editorial, :lugar, :traduccion, :edicion, :anio, :link, :link_vid, :portada, tematica:[])
    elsif params[:set] == "Personal del Directorio"
      params.require(:directorio).permit(:nombre, :centro, :temas, :correo, :sitio, :beca)
    elsif params[:set] == "Boletines"
      params.require(:boletin).permit(:titulo, :fecha, :documento)
    end
  end
end
