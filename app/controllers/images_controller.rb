class ImagesController < ApplicationController
  def new
    @image = Image.new
  end

  def create
    @image = Image.new(image_params)
    redirect_to "/"
  end

  private

  def image_params
    params.require(:image).permit(
      :url
    )
  end

end
