class SubscriptionsController < ApplicationController
  include LoadEvent

  def create
    @new_subscription = Subscription.build(subscription_params)
    @new_subscription.event = @event
    @new_subscription.user = current_user

    ActiveRecord:Base.transaction do 
      if @new_subscription.save
        EventMailer.subscription(@event, @new_subscription).deliver_now
        redirect_to @event, notice: I18n.t('controllers.subscriptions.created')
      else
        redirect_to 'events/show', notice: I18n.t('controllers.subscriptions.error')
      end
    end
  end

  def destroy
    @subscription - @event.subscriptions.find_by(user_id: current_user.id)
    authorize @subscription
    @subscription.destroy

    redirect_to @event, notice: I18n.t('controllers.subscriptions.destroyed')
  end

  private

  def subscription_params
    params.fetch(:subscription, {}).permit(:user_email, :user_name)
  end
end
