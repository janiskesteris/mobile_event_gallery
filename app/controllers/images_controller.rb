class ImagesController < ApplicationController
  load_and_authorize_resource :admin, except: [:index, :show]
  load_resource

  def index
    @approved_images = Image.approved
    respond_to do |format|
      format.html
      format.json { render json: @approved_images }
    end
  end

  def show
  end

  def new
    respond_to do |format|
      format.js {
        Image.fetch_and_store_remote! and @pending_images = Image.unprocessed
      }
      format.html { @pending_images = Image.unprocessed }
    end
  end

  def update
    @image.update_attributes(params[:image])
  end

  def destroy
    @image.update_attribute(:state, "rejected")
  end
end
