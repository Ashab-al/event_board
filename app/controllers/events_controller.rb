class EventsController < ApplicationController
  include LoadEvent
  before_action :authenticate_user!, only: [:new, :edit, :update, :destroy, :add_pictures]  
  before_action :password_guard!, only: [:show]

  def index 
    @events = Event.all
  end

  def show
    @user = @event.user
    @pictures = @event.pictures.sample(4)
    @new_subscription = @event.subscriptions.build(params[:subscription]) end

  def new
    @event = current_user.events.build
  end

  def edit
    authorize @event
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to @event, notice: I18n.t('controllers.events.created')
    else
      render :new, notice: I18n.t('controllers.events.error')
    end
  end
  
  def update
    if @event.update(event_params)
      redirect_to @event, notice: I18n.t('controllers.events.updated')
    else
      render :edit
    end
  end

  def destroy
    authorize @event

    @event.destroy

    redirect_to events_url, notice: I18n.t('controllers.events.destroyed')
  end

  def add_pictures
    authorize @event

    if params[:post][:pictures].present?
      params[:post][:pictures].each { |picture| @event.pictures.attach(picture) }
      redirect_to @event, notice: I18n.t('controllers.events.updated')
    else
      redirect_to @event, notice: I18n.t('controllers.events.error')
    end

  end

  def gallery
    authorize @event

    @pictures = @event.pictures
  end

  private

  def password_guard!
    result = PasswordGuardInteractor.call(event: event, pincode: params[:pincode])

    return if result.success?

    flash.now[:alert] = result.message
    render 'pincode_form'
  end

  def event_params
    params.require(:event).permit(:title, :description, :address, :datetime, :image, :pincode)
  end
end
