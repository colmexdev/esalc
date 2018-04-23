class PrincipalController < ApplicationController
  def principal
    @datos = []
    begin
      cliente = TinyTds::Client.new username: 'agendaPRED', password: '@g3NDa#', host: '172.16.40.220', port: '1433'
      @resultado = cliente.execute("USE Agenda")
      @resultado.do
      @resultado = cliente.execute("SELECT * FROM dbo.vw_EventosCategoria WHERE LOWER(CATEGORIA) LIKE '%estudios sobre américa latina%' ORDER BY PARSE(fechaInicio AS DATE USING 'es-ES') ASC, horaInicio ASC")
      #@resultado = cliente.execute("SELECT * FROM dbo.vw_EventosCategoria WHERE DATEADD(day, DATEDIFF(day,'19000101',PARSE(fechaFin AS DATE USING 'es-ES')), CAST(horaFin AS DATETIME2(1))) >= CAST(GETDATE() AS DATETIME2(1))  ORDER BY PARSE(fechaInicio AS DATE USING 'es-ES') ASC, horaInicio ASC")
      @resultado.each do |r|
        @datos << r
      end
    rescue
      @datos = {}
    end
    respond_to do |format|
      format.html
      format.json {render json: {videos: @resultado}}
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
