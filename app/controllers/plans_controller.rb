require "stripe"
require 'money'

PLANS_DESCRIPTIONS = {
	Basic: 'Attend private parties every other Friday at the most popular bars, with the possibility to bring any number of guests. Each additional guest costs $19.99 every month.',
	Classic: 'Get ahead of the line at popular restaurants in San Francisco, plus other perks. Add first five guests for FREE. Each additional guest costs $99.99 every month.',
	Modern: 'Have access to private lounges through out San Francisco, VIP access to relevant
    events and concerts all over the Bay Area, including chauffeur when required. Add first five guests for FREE. Each additional guest costs $199.99 every month.',
	
}

class PlansController < ApplicationController
  def index
		Stripe.api_key = Rails.application.secrets[:stripe_api_key]
		@plans = Stripe::Plan.list(limit: 6).sort_by { |plan| plan.id }
		user = User.find(session[:user_id])
		if user.token
			stripe_subscriptions = Stripe::Subscription.list(:customer => user.token)
		else
			stripe_subscriptions = []
		end
		@subscriptions = stripe_subscriptions.map { |s| s.plan.id }
  end

  def show
  	Stripe.api_key = Rails.application.secrets[:stripe_api_key]
  	@plan = Stripe::Plan.retrieve(params[:id])
  	user = User.find(session[:user_id])
  	@payment_method = user.present? && user.payments.last
  end

  def create
  	Stripe.api_key = Rails.application.secrets[:stripe_api_key]
  	user = User.find(session[:user_id])
		Stripe::Subscription.create(
		  :customer => user.token,
		  :items => [
		    {
		      :plan => params[:plans][:id],
		    },
		  ],
		  :metadata => {
		  	num_free_guests: params[:num_free_guests],
		  	num_paid_guests: params[:num_paid_guests]
		  }
		)
		redirect_to plans_index_path
  end

end
