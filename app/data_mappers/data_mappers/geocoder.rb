module DataMappers
  class Geocoder
    attr_accessor :data_hash, :mapped_hash

    MAPPING = {
      'formatted_address' => 'full_address',
      'street_number' => 'street_number',
      'route' => 'route',
      'locality'=> 'city',
      'administrative_area_level_1' => 'state_province',
      'country' => 'country',
      'postal_code' => 'postal_code' 
    }

    def initialize(data_hash)
      @data_hash = data_hash.with_indifferent_access
      @mapped_hash = Hash[MAPPING.values.map {|key| [key, nil]}]
    end

    def mapped
      data_hash['address_components'].each do |component|
        geocoder_map_type = (MAPPING.keys & component['types']).join(',')
        if geocoder_map_type.present?
          mapped_hash[MAPPING[geocoder_map_type]] = component['long_name']
        end
      end
      mapped_hash['full_address'] = data_hash['formatted_address']
      mapped_hash
    end
  end
end
