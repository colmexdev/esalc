class PrincipalController < ApplicationController
  def principal
    consulta_eventos
    respond_to do |format|
      format.html
      format.json {render json: {videos: @datos}}
    end
  end

  def revistas
    @unit = "revistas"
    respond_to do |format|
      format.html { render :catalogo}
    end
  end

  def tesis
    @unit = "tesis"
    respond_to do |format|
      format.html { render :catalogo}
    end
  end

  def publicaciones
    @unit = "pub-colmex"
    respond_to do |format|
      format.html { render :catalogo}
    end
  end

end
