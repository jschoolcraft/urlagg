class PagesController < ApplicationController
  def show
    template = params[:id] || 'index'
    render template
  end
end