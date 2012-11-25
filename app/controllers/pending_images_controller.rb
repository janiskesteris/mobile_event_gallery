class PendingImagesController < ApplicationController
  load_and_authorize_resource :admin

  def new
  end
end
