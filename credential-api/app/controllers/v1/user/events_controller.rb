class V1::User::EventsController < V1::User::UserController
  before_action :set_institution
  before_action :set_event, only: [:state]

  def index
    @q = Event.joins(:institution).where(institution: { id: @institution.id }).ransack(params[:q])
    @pagy, @events = pagy(@q.result)
    render json: @events
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  def create
    result = ::Events::Create.result(attributes: event_params)
  
    if result.success?
      render json: result.event, status: :created
    else
      render json: { error: { message: result.error } }, status: :unprocessable_entity
    end
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  def state
    result = ::Events::Start.result(event: @event)

    if result.success?
      render json: result.event, status: :ok
    else
      render json: { error: { message: result.error } }, status: :unprocessable_entity
    end
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  private

  def event_params
    params.require(:event).permit(:name, metadata: {}).merge(institution_id: @institution.id).to_h
  end

  def set_event
    @event = policy_scope(Event).find(params[:id])
  end

  def set_institution
    @institution = policy_scope(Institution).find(params[:institution_id])
  end
end
