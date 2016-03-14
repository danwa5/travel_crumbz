FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }

    trait :with_trip do
      after(:build) {|user| user.trips = [create(:trip, user_ids: [user.id])]}
    end
  end

  factory :trip do
    trait :with_user do
      after(:build) {|trip| trip.users = [create(:user)]}
    end
    trait :with_location do
      after(:build) {|trip| trip.locations = [create(:location)]}
    end
  end

  factory :location do
    city { Faker::Address.city }
    country { Faker::Address.country }
    formatted_address { [city, country].join(', ') }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
