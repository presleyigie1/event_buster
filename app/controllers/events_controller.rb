class EventsController < ApplicationController
  # Use callbacks to share common setup or constraints between actions.
  before_action :set_event, only: %i[show edit update destroy]
  # Restrict access to admin users for certain actions
  before_action :require_admin, only: %i[new create edit update destroy]

  # GET /events or /events.json
  def index
    # Fetch all events for display
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show
    # Show details of a single event
    @registrations = @event.registrations
  end

  # GET /events/new
  def new
    # Initialize a new event instance
    @event = Event.new
  end

  # POST /events or /events.json
  def create
    # Create a new event with the provided parameters
    @event = Event.new(event_params)

    # Check if the event was saved successfully
    if @event.save
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # GET /events/1/edit
  def edit
    # Edit an existing event
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    # Update an event with the provided parameters
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    # Destroy an existing event
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:name, :description, :location, :date)
  end

  # Restrict access to admin users only
  def require_admin
    unless current_user&.role == 'admin'
      redirect_to events_path, alert: 'Access denied.'
    end
  end
end
