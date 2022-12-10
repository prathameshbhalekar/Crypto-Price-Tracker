class AlertsController < ApplicationController
  before_action :authorize_request

  def create
    symbol = params[:symbol] || "bitcoin"

    @alert = Alert.new(
      trigger: params[:trigger], 
      is_active: true,
      symbol: symbol,
      user: @current_user,
    )

    if @alert.save
      render json: {msg: "Created Alert", data: @alert}, status: :created
    else
      render json: { err: @alert.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def allAlerts
    is_active = params[:is_active] || "all"
    symbol = params[:symbol] || "all"

    @alerts = @current_user.getAllAlerts(is_active, symbol)

    render json: {msg: "Success", data: @alerts}, status: :ok    
  end

  def deleteAlert
    @alerts = Alert.where(user: @current_user, id: params[:id])
    
    if @alerts.count == 0
      return render json: {err: "Alert with Id not found"}, status: :not_found
    end

    @alerts.destroy_all
    render json: {msg: "Deleted Successfully"}, status: :ok    
  end

end
