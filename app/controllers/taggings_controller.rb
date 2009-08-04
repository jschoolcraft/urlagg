class TaggingsController < ApplicationController
  def create
      @tag = current_user.track_tag(params[:tag] && params[:tag][:name])
      if @tag.new_record?
      else
        flash[:notice] = "Now tracking #{@tag.name}"
      end
      redirect_to tags_path
  end
  
  def destroy
    @tag = current_user.untrack_tag(params[:id])
    if @tag
      flash[:notice] = "Stopped tracking #{@tag.name}"
    end
    redirect_to tags_path
  end
end