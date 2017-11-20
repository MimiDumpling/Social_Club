require "stripe"

class PaymentsController < ApplicationController

  def create
    @payment = Payment.new(payment_params.merge({ user_id: session[:user_id] }))
 
    if @payment.save
      create_customer
      render json: @payment.to_json, status: 200
    else
      render json: { errors: @payment.errors.full_messages }, status: 422
    end
  end

  private
    def payment_params
      params.require(:payment).permit(:vendor, :token, :last_4, :card_type)
    end

    def create_customer
      Stripe.api_key = Rails.application.secrets[:stripe_api_key]
      user = User.find(session[:user_id])
      customer = Stripe::Customer.create(
        :description => "Customer for #{user.email}",
        :source => user.payments.last.token # obtained with Stripe.js
      )
      user.update_column(:token, customer.id)
      
    end 
end
