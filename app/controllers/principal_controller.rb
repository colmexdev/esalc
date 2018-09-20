class PrincipalController < ApplicationController
  def principal
  end

  def libros
  end

  def directorio
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

  def publicaciones
    @unit = "pub-colmex"
    respond_to do |format|
      format.html { render :catalogo}
    end
  end

end
