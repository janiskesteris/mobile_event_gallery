class ImagesController < ApplicationController
  load_and_authorize_resource :admin
  load_resource

  def new
    @pending_images = Image.fetch_and_store_remote! and Image.unprocessed
  end

  def update
    @image.update_attributes(params[:image])
  end

  def destroy
    @image.destroy
  end
end
