class StaticPagesController < ApplicationController

  def home
    @trips = Trip.all
  end
  
end