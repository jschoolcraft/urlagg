class UsersController < ApplicationController
  before_filter :require_user, :except => [ :show, :summary ]
  def show
    @user = User.find(params[:id])
    @links = @user.latest_popular_links
    respond_to do |format|
      format.atom do
        render
      end
      # format.html { render }
    end
  end
  
  def summary
    @user = User.find(params[:id])
    @tags_with_links, @latest_update = @user.todays_links
    logger.debug("tags_with_links: #{@tags_with_links.inspect}")
    respond_to do |format|
      format.atom do
        render
      end
    end
  end
  
  def update
    @user = current_user
    @user.update_attributes(:last_viewed_tags_index_at => Time.now)
    redirect_to tags_path
  end
end
