module LoadEvent
  extend ActiveSupport::Concern

  included do 
    before_action :set_event, only: [:create, :destroy]
  end

  private 
  
  def set_event
    @event = Event.find(params[:event_id])
  end
end