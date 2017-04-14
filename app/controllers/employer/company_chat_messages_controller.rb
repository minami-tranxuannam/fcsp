class Employer::CompanyChatMessagesController < Employer::BaseController
  # load_and_authorize_resource
  before_action :load_support_object, only: [:index, :new]

  def index
    respond_to do |format|
      format.js{}
    end
  end

  def new
  end

  private

  def load_support_object
    @messages_object = Supports::Message.new current_user, params
  end
end
