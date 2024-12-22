class RegistrationsController < ApplicationController
  before_action :set_event


   # Allows users to register for an event. Admins cannot register.
   def create
    if current_user.admin?
      redirect_to @event, alert: 'Admins cannot register for events.'
      return
    end

    @registration = @event.registrations.build(user: current_user)

    if @registration.save
      redirect_to @event, notice: 'You have successfully registered for this event.'
    else
      redirect_to @event, alert: 'Registration failed.'
    end
  end

  # destroys a registration. Admins can remove any registration, while users can only remove their own.
  #
  # the ID of the registration to be destroyed.
  # redirects to the event page with a notice or alert message.
  def destroy
    # Admin can remove any registration; users can only remove their own
    @registration = if current_user.admin?
                      @event.registrations.find(params[:id]) # Admin removes by ID
                    else
                      @event.registrations.find_by(user: current_user) # User removes their own
                    end

    if @registration
      @registration.destroy
      redirect_to @event, notice: 'Registration was successfully removed.'
    else
      redirect_to @event, alert: 'Unable to find registration.'
    end
  end

  private

  # sets the event associated with the current registration.
  # the ID of the event.
  # the event associated with the current registration.
  def set_event
    @event = Event.find(params[:event_id])
  end
end
