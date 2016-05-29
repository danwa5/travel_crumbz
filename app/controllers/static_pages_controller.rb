class StaticPagesController < ApplicationController

  def discover
    @trips = Trip.all
  end
  
end