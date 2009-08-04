class TagsController < ApplicationController
  before_filter :require_user, :except => ["show", "summary", "top"]
  
  def index
    @user = current_user
    @tag = Tag.new
    
    @tags = @user.tags
    @taggings = @user.taggings
    @recent_taggings = Tag.recent_taggings
  end
  
  def top
    @tags = Tag.top
  end
  
  def show
    respond_to do |format|
      format.html do
        @tags = current_user && current_user.tags
        @recent_taggings = Tag.recent_taggings
        if params[:tag]
          @tag = Tag.find_by_name(params[:tag])
        else
          @tag = Tag.find(params[:id])
        end
        
        if @tag
          page_param = params[:page] && params[:page].to_i
          page = page_param == 0 ? 1 : page_param
          @links = @tag.links.paginate(:page => page, :per_page => 20)
        else
          @tag = Tag.new(:name => params[:tag])
          render :action => 'not_tracking' and return
        end
      end
      
      format.atom do
        @tag = Tag.find(params[:id])
        @links = @tag.links.paginate(:page => 1, :per_page => 30)
      end
    end
  end
  
  def summary
    @tag = Tag.find(params[:id])
    @links = @tag.todays_links
    respond_to do |format|
      format.atom { render }
    end
  end

  def read
    @tag = current_user.tags.find(params[:id])
    @tag.mark_read_for(current_user)
    redirect_to tags_path
  end
end