class PostsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json { render json: PostsDatatable.new(view_context) }
    end
  end
end
