class PasswordGuardInteractor
  include Interactor

  def call
    event = context.event 
    pincode = context.pincode

    context.success if @event.pincode.blank?
    context.success if signed_in? && current_user == @event.user

    if params[:pincode].present? && @event.pincode_valid?(params[:pincode])
      cookies.permanent["events_#{@event.id}_pincode"] = params["pincode"]
    end

    unless @event.pincode_valid?(cookies.permanent["events_#{@event.id}_pincode"])
      context.fail(message: I18n.t('controllers.events.wrong_pincode')) if params[:pincode].present?
      context.fail(message: 'Invalid pincode')
    end
  end
end