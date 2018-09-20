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
  end

  def lengua_literatura
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def partidos_politicos
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def relaciones_internacionales
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def sociedad_economia
    respond_to do |format|
      format.html {render :historia}
    end
  end

  def violencia
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
