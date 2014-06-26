class PredictionsController < ApplicationController
  before_action :set_prediction, only: [:show, :edit, :update, :destroy]

  # GET /predictions
  # GET /predictions.json
  def index
    @predictions = Prediction.all
  end

  # GET /predictions/1
  # GET /predictions/1.json
  def show
  end

  # GET /predictions/new
  def new
    @prediction = Prediction.new
  end

  # GET /predictions/1/edit
  def edit
  end

  # POST /predictions
  # POST /predictions.json
  def create
    @prediction = Prediction.new(prediction_params)
	
	require 'classifier'
  lsi = Classifier::LSI.new
 # strings = [ ["Tarjeta madre ASUS.", :hardware],
  #            ["SO Windows 8.1 basic ", :software],
   #           ["Antivirus Kaspersky 2014 IS.", :software],
    #          ["Tableta Ipad mini 32 gb", :hardware],
		
    #          ["Bocinas Acteck 5.1",:harware ]]
#  strings.each {|x| lsi.add_item  x.first, x.last}
 strings = [ ["This text deals with dogs. Dogs.", :dog],
              ["This text involves dogs too. Dogs! ", :dog],
              ["This text revolves around cats. Cats.", :cat],
              ["This text also involves cats. Cats!", :cat],
              ["This text involves birds. Birds.",:bird ]]
  strings.each {|x| lsi.add_item x.first, x.last}
   lsi.find_related(strings[2], 2)



	
	para= params[:tag].to_s
	
	lsi.find_related(para, 2)
  

    respond_to do |format|
      if @prediction.save
	   format.html { render action: 'tagged' }
       format.html { redirect_to @prediction, notice: 'Prediction was successfully created.' }
        format.json { render action: 'show', status: :created, location: @prediction }
      else
        format.html { render action: 'new' }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
	
end
  # PATCH/PUT /predictions/1
  # PATCH/PUT /predictions/1.json
  def update
    respond_to do |format|
      if @prediction.update(prediction_params)
        format.html { redirect_to @prediction, notice: 'Prediction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @prediction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /predictions/1
  # DELETE /predictions/1.json
  def destroy
    @prediction.destroy
    respond_to do |format|
      format.html { redirect_to predictions_url }
      format.json { head :no_content }
    end
  end
  
  def  tagged
   @predictions = Prediction.find(:limit => 10)
	 respond_to do |format|
        format.html {render action: "index"}
	 end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_prediction
      @prediction = Prediction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def prediction_params
      params.require(:prediction).permit(:product, :tag)
    end
end
