class V1::User::CredentialEventsController < V1::User::UserController
  before_action :set_event

  def index
    @q = Credential.joins(:credential_events).where(credential_events: { event_id: @event.id }).ransack(params[:q])
    @pagy, @events = pagy(@q.result)
    render json: @events
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  def create
    result = ::V1::Credentials::Create.result(event: @event, attributes: credential_params)
  
    if result.success?
      render json: result.event, status: :created
    else
      render json: { error: { message: result.error } }, status: :unprocessable_entity
    end
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  def state
    result = ::V1::Credentials::State.result(event: @event, state: params[:state])

    if result.success?
      render json: result.event, status: :ok
    else
      render json: { error: { message: result.error } }, status: :unprocessable_entity
    end
  rescue => exception
    render json: { error: { message: exception.message } }, status: :unprocessable_entity
  end

  private

  def credential_params
    params.require(:credential).permit(:name, :author, :metadata).merge(institution_id: @event.institution_id).to_h
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
