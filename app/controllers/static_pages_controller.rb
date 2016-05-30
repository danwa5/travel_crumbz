class StaticPagesController < ApplicationController

  def discover
    if search_params.empty?
      @trips = Trip.all
    else
      @trips = SearchForm.search(search_params)
    end
  end

  private

  def search_params
    params.permit(:keywords)
  end
  
end