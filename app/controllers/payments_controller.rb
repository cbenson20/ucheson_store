class PaymentsController < ApplicationController
  # Stripe Payment Integration

  def create
    @order = Order.find(params[:order_id])

    begin
      # Create Stripe payment intent
      payment_intent = Stripe::PaymentIntent.create({
        amount: (@order.total * 100).to_i, # Stripe expects cents
        currency: 'usd', # Changed from 'ngn' to 'usd' for testing
        metadata: {
          order_id: @order.id,
          customer_email: @order.user.email # Fixed: get email from user
        }
      })

      # Update order with payment intent ID
      @order.update(
        payment_intent_id: payment_intent.id,
        payment_status: 'pending'
      )

      render json: { clientSecret: payment_intent.client_secret }
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def confirm
    @order = Order.find_by(payment_intent_id: params[:payment_intent_id])

    if @order
      # Verify payment with Stripe
      payment_intent = Stripe::PaymentIntent.retrieve(params[:payment_intent_id])

      if payment_intent.status == 'succeeded'
        @order.update(
          payment_status: 'paid',
          status: 'paid'
        )

        # Clear the cart
        session[:cart] = {}

        redirect_to order_path(@order), notice: 'Payment successful! Your order has been confirmed.'
      else
        redirect_to order_path(@order), alert: 'Payment failed. Please try again.'
      end
    else
      redirect_to root_path, alert: 'Order not found.'
    end
  end

  def webhook
    # Handle Stripe webhooks
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET']
      )

      case event.type
      when 'payment_intent.succeeded'
        payment_intent = event.data.object
        order = Order.find_by(payment_intent_id: payment_intent.id)
        order&.update(payment_status: 'paid', status: 'paid')
      when 'payment_intent.payment_failed'
        payment_intent = event.data.object
        order = Order.find_by(payment_intent_id: payment_intent.id)
        order&.update(payment_status: 'failed')
      end

      render json: { message: 'success' }
    rescue JSON::ParserError, Stripe::SignatureVerificationError => e
      render json: { error: e.message }, status: 400
    end
  end
end
