class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
 
  require 'classifier'
  parametro= params[:description].to_s
b = Classifier::Bayes.new('Servicio', 'Ventas')


File.open('C:\Sites\inteligencia\bayes\app\controllers\servicio.txt', 'r') do |f1|
  while linea = f1.gets
    b.train_servicio linea.to_s
  end
end

#Message.find_each(:conditions => "depto == 'Servicio'") do |message|
 #   b.train_servicio message.description.to_s
  #end


 #File.open('C:\Sites\inteligencia\bayes\app\controllers\ventas.txt', 'r') do |f1|
 # while linea = f1.gets
  #  b.train_ventas linea.to_s
  #end
#end  

b.train_servicio "mi computadora se descompuso no sirve el mouse"
b.train_ventas "cotizar 100 servidores supermicri"
b.train_ventas "necesito 4 servidores sun"
b.train_ventas "venden aires acondicionados?"
b.train_servicio "reparar computadoras rotas descompuestas"

b.classify(parametro)
if b.classify(parametro) == "Servicio" 

 @message = Message.new(message_params)
 @message.depto = "Servicio"
 
elsif b.classify(parametro) == "Ventas" 
 @message = Message.new(message_params)
 @message.depto= "Ventas"
end
  


    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render action: 'show', status: :created, location: @message }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  
   def servicio
    @messages = Message.find(:limit => 10, :order => 'depto id desc')
    respond_to do |format|
        format.html {render action: "index"}
	end
  end
  
  
  
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:title, :description, :depto)
    end
end
