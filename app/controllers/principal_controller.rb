class PrincipalController < ApplicationController
  def principal
    @pubs = Publicacion.order(anio: :desc, updated_at: :desc).limit(4)
  end

  def libros
  end

  def directorio
    where = ""
    if params.key?(:conds)
      where = build_where(params[:conds])
    end
    limite = 5.0
    @profs_c = Directorio.where(where).count
    @profs = Directorio.where(where).order(nombre: :asc).offset(params.key?(:offset) ? (params[:offset].to_i * limite) : 0).limit(limite)
    @pags = @profs_c/limite.ceil
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
    return where
  end

  def videoteca
  end

  def historia
    @tema = "Historia"
  end

  def lengua_literatura
    @tema = "Lengua y literatura"
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def partidos_politicos
    @tema = "Política, partidos e instituciones"
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def relaciones_internacionales
    @tema = "Relaciones internacionales"
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def sociedad_economia
    @tema = "Sociedad y economía"
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def violencia
    @tema = "Violencia y Derechos Humanos"
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def articulos
  end

  def revistas
    @unit = "revistas"
    respond_to do |format|
      format.html { render :catalogo}
    end
  end

  def tesis
   # @unit = "tesis"
   # respond_to do |format|
   #   format.html { render :catalogo}
   # end
  end

  def eventos
  end

  def seminarios
  end

  def publicaciones
    @unit = "pub-colmex"
    respond_to do |format|
      format.html { render :catalogo}
    end
  end

end
