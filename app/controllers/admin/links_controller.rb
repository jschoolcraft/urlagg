class Admin::LinksController < Admin::Base
  resource_controller
  
  def reports
    @links_without_bookmarks = Link.count(:all, :conditions => ['links.bookmarks = 0'])
    @links_with_nil_bookmarks = Link.count(:all, :conditions => ['links.bookmarks IS NULL'])
    @links_with_bookmarks = Link.count(:all, :conditions => ['links.bookmarks > 0'])
    @links_pending_update = Link.count(:all, :conditions => [
        "(links.bookmarks <= ? AND links.updated_at >= ?)", Link.threshold, 1.week.ago
      ])
    threshold = 500
    @distributions = []
    while (count = Link.count_bookmarks(threshold)) > 0
      @distributions << [threshold, count]
      threshold *= 2
    end
      
  end

  protected
    def allowed_columns
      @allowed_columns ||= %w[title created_at updated_at bookmarks]
    end
    
    def sort_direction
      params[:sort] =~ /_reverse/ ? 'desc' : 'asc'
    end
    
    def sort_column
      column = params[:sort] && params[:sort].gsub(/_reverse/, '')
      if allowed_columns.include?(column)
        column
      else
        allowed_columns.first
      end
    end
    
    def sort_clause
      "#{sort_column} #{sort_direction}"
    end
    
    def collection
      params[:sort] =~ /_reverse/
      @collection ||= end_of_association_chain.find(:all, :order => sort_clause).paginate(:page => params[:page])
    end
end