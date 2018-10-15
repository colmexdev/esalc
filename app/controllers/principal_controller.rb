class PrincipalController < ApplicationController
  def principal
    @pubs = Publicacion.order(anio: :desc, updated_at: :desc).limit(4)
  end

  def libros
    where = ""
    if params.key?(:conds)
      where = build_where(params[:conds])
    end
    limite = 10.0
    @pubs_c = Publicacion.where(where).count
    @pubs = Publicacion.where(where).order(updated_at: :desc).offset(params.key?(:offset) ? (params[:offset].to_i * limite) : 0).limit(limite)
    @pags = (@pubs_c/limite).ceil
    respond_to do |format|
      format.html
      format.js
    end
  end

  def directorio
    where = ""
    if params.key?(:conds)
      where = build_where(params[:conds])
    end
    limite = 5.0
    @profs_c = Directorio.where(where).count
    @profs = Directorio.where(where).order(nombre: :asc).offset(params.key?(:offset) ? (params[:offset].to_i * limite) : 0).limit(limite)
    @pags = (@profs_c/limite).ceil
    respond_to do |format|
      format.html
      format.js
    end
  end

  def videoteca
    @url = "?" + (params.key?(:offset) ? ("offset=" + params[:offset]) : "") + (params.key?(:conds) ? ((params[:conds].key?(:tema) ? "&tema=" + params[:conds][:tema] : "") + (params[:conds].key?(:autor) ? "&autor=" + params[:conds][:autor] : "") + (params[:conds].key?(:pais) ? "&pais=" + params[:conds][:pais] : "") + (params[:conds].key?(:fecha) ? "&fecha=" + params[:conds][:fecha] : "")) : "")
    respond_to do |format|
      format.html
      format.js
    end
  end

  def historia
    @tema = "Historia"
    where = "lower(tematica) like '%historia%'"
    #@profs = Directorio.where(where)
    @revs = Revista.where(where).each {|m| m[:sect] = "rev" }
    @pubs = Publicacion.where(where).each {|m| m[:sect] = "pub" }
    @tesis = Tesis.where(where).each {|m| m[:sect] = "tesis" }
    @url = "?" + "tema=historia"
    respond_to do |format|
      format.html
      format.js
    end
  end

  def lengua_literatura
    @tema = "Lengua y literatura"
    where = "lower(tematica) like '%lengua%'"
    #@profs = Directorio.where(where)
    @revs = Revista.where(where)
    @pubs = Publicacion.where(where)
    @tesis = Tesis.where(where)
    @url = "?" + "tema=lengua y literatura"
    respond_to do |format|
      format.html {render :historia}
      format.js {render :historia}
    end
  end

  def partidos_politicos
    @tema = "Política, partidos e instituciones"
    where = "lower(tematica) like '%pol_tic%'"
    #@profs = Directorio.where(where)
    @revs = Revista.where(where)
    @pubs = Publicacion.where(where)
    @tesis = Tesis.where(where)
    @url = "?" + "tema=politic"
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def relaciones_internacionales
    @tema = "Relaciones internacionales"
    where = "lower(tematica) like '%internacionales%'"
    #@profs = Directorio.where(where)
    @revs = Revista.where(where).each {|m| m[:sect] = "rev" }
    @pubs = Publicacion.where(where).each {|m| m[:sect] = "pub" }
    @tesis = Tesis.where(where).each {|m| m[:sect] = "tesis" }
    @url = "?" + "tema=relaciones internacionales"
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def sociedad_economia
    @tema = "Sociedad y economía"
    where = "lower(tematica) like '%econ_m%'"
    #@profs = Directorio.where(where)
    @revs = Revista.where(where)
    @pubs = Publicacion.where(where)
    @tesis = Tesis.where(where)
    @url = "?" + "tema=econom"
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def violencia
    @tema = "Violencia y Derechos Humanos"
    where = "lower(tematica) like '%violencia%'"
    #@profs = Directorio.where(where)
    @revs = Revista.where(where)
    @pubs = Publicacion.where(where)
    @tesis = Tesis.where(where)
    @url = "?" + "tema=violencia"
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def articulos
    where = ""
    if params.key?(:conds)
      where = build_where(params[:conds])
    end
    limite = 10.0
    @mags_c = Revista.where(where).count
    @mags = Revista.where(where).order(updated_at: :desc).offset(params.key?(:offset) ? (params[:offset].to_i * limite) : 0).limit(limite)
    @pags = (@mags_c/limite).ceil
    respond_to do |format|
      format.html
      format.js
    end
  end

  def build_where(pars)
    where = ""
    multi = false
    if pars.key?(:inicial)
      where = "nombre like '" + pars[:inicial] + "%'"
      multi = true
    end
    if pars.key?(:centros)
      where = where + (multi ? " AND " : "") + "centro = '" + pars[:centros].upcase + "'"
      multi = true
    end
    if pars.key?(:nombre)
      where = where + (multi ? " AND " : "") + "lower(nombre) like '%" + pars[:nombre].downcase + "%'"
      multi = true
    end
    if pars.key?(:autor)
      where = where + (multi ? " AND " : "") + "lower(autores) like '%" + pars[:autor].downcase + "%'"
      multi = true
    end
    if pars.key?(:tema)
      where = where + (multi ? " AND " : "") + "lower(tematica) like '%" + pars[:tema].downcase + "%'"
      multi = true
    end
    if pars.key?(:programa)
      prog = pars[:programa].split(", en ")
      where = where + (multi ? " AND " : "") + "lower(grado) = '" + prog[0].downcase + "' AND lower(programa) = '" + prog[1] + "'"
      multi = true
    end
    if pars.key?(:fecha)
      where = where + (multi ? " AND " : "") + "anio = " + pars[:fecha]
      multi = true
    end
    return where
  end


  def tesis
    where = ""
    if params.key?(:conds)
      where = build_where(params[:conds])
    end
    limite = 10.0
    @tesis_c = Tesis.where(where).count
    @tesis = Tesis.where(where).order(titulo: :desc).offset(params.key?(:offset) ? (params[:offset].to_i * limite) : 0).limit(limite)
    @pags = (@tesis_c/limite).ceil
    respond_to do |format|
      format.html
      format.js
    end
  end

  def eventos
    @url = "?" + (params.key?(:offset) ? ("offset=" + params[:offset]) : "") + (params.key?(:conds) ? ((params[:conds].key?(:tipo) ? "&tipo=" + params[:conds][:tipo] : "") + (params[:conds].key?(:centros) ? "&centros=" + params[:conds][:centros] : "") + (params[:conds].key?(:fecha) ? "&fecha=" + params[:conds][:fecha] : "")) : "")
    respond_to do |format|
      format.html
      format.js
    end
  end

  def seminarios
    @url = "?" + (params.key?(:offset) ? ("offset=" + params[:offset]) : "") + (params.key?(:conds) ? (params[:conds].key?(:centros) ? ("&centros=" + params[:conds][:centros]) : "") : "")
    respond_to do |format|
      format.html
      format.js
    end
  end

end
