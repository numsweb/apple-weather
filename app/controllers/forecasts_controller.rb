class ForecastsController < ApplicationController
  before_action :set_forecast, only: %i[ show edit update destroy ]

  # GET /forecasts or /forecasts.json
  def index
    @forecasts = Forecast.all
  end

  # GET /forecasts/1 or /forecasts/1.json
  def show
  end

  # GET /forecasts/new
  def new
    @forecast = Forecast.new
  end

  # GET /forecasts/1/edit
  def edit
  end

  # POST /forecasts or /forecasts.json
  def create
    params.permit!

    #forecast_params = {location: [33.566574, -81.719398]}
    results = Geocoder.search(params[:forecast][:address])
    if results.first.present?
      #TODO Unfortunately the Geocoder returns a result even if it does not find a match
      # need to parse the result to see if it matches the requested address
      forecast_params = {location: results.first.coordinates, address: results.first.display_name}

    else
      flash.now.alert = "No result found"
      redirect_to forecasts_url,  notice: "Address not found" and return
    end

    respond_to do |format|
      #additional requirement, only create a new forecast if there is not an existing
      # one that is less than 30 minutes old

      @forecast_found = false

      Forecast.all.each do |forecast|
        if forecast.location.include?(forecast_params[:location].to_s) && forecast.created_at > 30.minutes.ago
          @forecast_found = true
          break
        end
      end
      if @forecast_found
        redirect_to forecasts_url, notice: "Forecast exists and is not expired." and return
      else
        @forecast = Forecast.new(forecast_params)

        if @forecast.find_and_save_forecast(forecast_params)
          format.html { redirect_to forecasts_url, notice: "Forecast was successfully created." }
          format.json { render :show, status: :created, location: @forecast }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @forecast.errors, status: :unprocessable_entity }
        end
      end

    end
  end

  # PATCH/PUT /forecasts/1 or /forecasts/1.json
  def update
    respond_to do |format|
      if @forecast.update(forecast_params)
        format.html { redirect_to forecast_url(@forecast), notice: "Forecast was successfully updated." }
        format.json { render :show, status: :ok, location: @forecast }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @forecast.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forecasts/1 or /forecasts/1.json
  def destroy
    @forecast.destroy!

    respond_to do |format|
      format.html { redirect_to forecasts_url, notice: "Forecast was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast
      @forecast = Forecast.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def forecast_params
      params.fetch(:forecast, {})
    end
end
