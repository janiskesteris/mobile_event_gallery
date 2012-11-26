class PendingImagesController < ApplicationController
  load_and_authorize_resource :admin

  def new
    @pending_images = Image.fetch_and_store_remote! and Image.unprocessed
  end
end
