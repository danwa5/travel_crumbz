require 'rails_helper'

RSpec.describe DataMappers::Geocoder, type: :model do
  describe '#mapped' do
    context 'when geocoder result is an empty address' do
      subject { described_class.new({ "address_components" => [] }) }
      it 'returns a mapped hash with no data' do
        expect(subject.mapped).to eq({
          'full_address' => nil,
          'street_number' => nil,
          'route' => nil,
          'city' => nil,
          'state_province' => nil,
          'country' => nil,
          'postal_code' => nil
        })
      end
    end

    context 'when geocoder result is a partial address (country)' do
      subject do
        described_class.new({
          "address_components" => [
            {"long_name"=>"Cambodia", "short_name"=>"KH", "types"=>["country", "political"]}
          ],
          "formatted_address" => "Cambodia",
          "geometry" => {
            "bounds" => {
              "northeast" => {"lat"=>14.6901791, "lng"=>107.627687},
              "southwest" => {"lat"=>9.2857541, "lng"=>102.333542}
            },
            "location" => {"lat"=>12.565679, "lng"=>104.990963},
            "location_type" => "APPROXIMATE",
            "viewport" => {
              "northeast" => {"lat"=>14.6901791, "lng"=>107.627687},
              "southwest" => {"lat"=>9.2857541, "lng"=>102.333542}
            }
          },
          "place_id" => "ChIJQzfc1L-HBzERUxL0ieC_t-Q",
          "types" => ["country", "political"]
        })
      end

      it 'returns a mapped hash with partial data' do
        expect(subject.mapped).to eq({
          'full_address' => 'Cambodia',
          'street_number' => nil,
          'route' => nil,
          'city' => nil,
          'state_province' => nil,
          'country' => 'Cambodia',
          'postal_code' => nil
        })
      end
    end

    context 'when geocoder result is a partial address (natural feature)' do
      subject do
        described_class.new({
          "address_components"=>[
            {"long_name"=>"Mount Kilimanjaro", "short_name"=>"Mount Kilimanjaro", "types"=>["natural_feature", "establishment"]},
            {"long_name"=>"Rombo", "short_name"=>"Rombo", "types"=>["administrative_area_level_2", "political"]},
            {"long_name"=>"Kilimanjaro", "short_name"=>"Kilimanjaro", "types"=>["administrative_area_level_1", "political"]},
            {"long_name"=>"Tanzania", "short_name"=>"TZ", "types"=>["country", "political"]}
          ],
          "formatted_address"=>"Mount Kilimanjaro, Tanzania",
          "geometry"=>{
            "location"=>{"lat"=>-3.0674247, "lng"=>37.35562729999999},
            "location_type"=>"APPROXIMATE",
            "viewport"=>{
              "northeast"=>{"lat"=>-3.0562826, "lng"=>37.3716347},
              "southwest"=>{"lat"=>-3.0785666, "lng"=>37.3396199}
            }
          },
          "place_id"=>"ChIJBahuOVr8ORgRAWzqjkccdI4",
          "types"=>["natural_feature", "establishment"]
        })
      end

      it 'returns a mapped hash with partial data' do
        expect(subject.mapped).to eq({
          'full_address' => 'Mount Kilimanjaro, Tanzania',
          'street_number' => nil,
          'route' => nil,
          'city' => nil,
          'state_province' => 'Kilimanjaro',
          'country' => 'Tanzania',
          'postal_code' => nil
        })
      end
    end

    context 'when geocoder result is a full address' do
      subject do
        described_class.new({
          "address_components" => [
            {"long_name"=>"602", "short_name"=>"602", "types"=>["subpremise"]},
            {"long_name"=>"375", "short_name"=>"375", "types"=>["street_number"]}, 
            {"long_name"=>"King Street West", "short_name"=>"King St W", "types"=>["route"]}, 
            {"long_name"=>"Entertainment District", "short_name"=>"Entertainment District", "types"=>["neighborhood", "political"]}, 
            {"long_name"=>"Old Toronto", "short_name"=>"Old Toronto", "types"=>["sublocality_level_1", "sublocality", "political"]}, 
            {"long_name"=>"Toronto", "short_name"=>"Toronto", "types"=>["locality", "political"]}, 
            {"long_name"=>"Toronto Division", "short_name"=>"Toronto Division", "types"=>["administrative_area_level_2", "political"]}, 
            {"long_name"=>"Ontario", "short_name"=>"ON", "types"=>["administrative_area_level_1", "political"]}, 
            {"long_name"=>"Canada", "short_name"=>"CA", "types"=>["country", "political"]}, 
            {"long_name"=>"M5V 1K5", "short_name"=>"M5V 1K5", "types"=>["postal_code"]}
          ],
          "formatted_address" => "375 King St W #602, Toronto, ON M5V 1K1, Canada",
          "geometry" => {
            "location" => {"lat"=>43.645641, "lng"=>-79.3929534},
            "location_type" => "ROOFTOP",
            "viewport" => {
              "northeast" => {"lat"=>43.64698998029149, "lng"=>-79.3916044197085},
              "southwest" => {"lat"=>43.6442920197085, "lng"=>-79.3943023802915}
            }
          },
          "place_id" => "Ei8zNzUgS2luZyBTdCBXICM2MDIsIFRvcm9udG8sIE9OIE01ViAxSzEsIENhbmFkYQ",
          "types" => ["subpremise"] # ["point_of_interest", "establishment"], ["natural_feature", "establishment"]
        })
      end

      it 'returns a mapped hash with full data' do
        expect(subject.mapped).to eq({
          'full_address' => '375 King St W #602, Toronto, ON M5V 1K1, Canada',
          'street_number' => '375',
          'route' => 'King Street West',
          'city' => 'Toronto',
          'state_province' => 'Ontario',
          'country' => 'Canada',
          'postal_code' => 'M5V 1K5'
        })
      end
    end
  end
end
