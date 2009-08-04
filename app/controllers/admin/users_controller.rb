class Admin::UsersController < Admin::Base 
  resource_controller
  
  protected
    def collection
      @collection ||= end_of_association_chain.paginate(:page => params[:page])
    end
end