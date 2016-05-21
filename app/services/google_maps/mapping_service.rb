module GoogleMaps
  class MappingService

    def self.call(locations)
      location_hash = Gmaps4rails.build_markers(locations) do |location, marker|
        marker.lat location.latitude
        marker.lng location.longitude
        marker.title location.label
        marker.infowindow location.full_address
      end
    end

  end
end
