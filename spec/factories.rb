FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:username) { |n| "#{first_name}#{n}".downcase }
    email { Faker::Internet.email }
    password '111111'
    email_confirmed true

    trait :with_trip do
      after(:build) { |user| user.trips = [create(:trip, user_ids: [user.id])] }
    end

    trait :with_3_trips do
      after(:build) do |user|
        user.trips = create_list(:trip, 3, user_ids: [user.id])
      end
    end
  end

  factory :trip do
    sequence(:name) { |n| "Trip ##{n}" }

    trait :with_user do
      after(:build) { |trip| trip.users = [create(:user)] }
    end
    trait :with_location do
      after(:build) { |trip| trip.locations.build(FactoryGirl.attributes_for(:location)) }
    end
    trait :with_2_locations do
      after(:build) do |trip|
        2.times do
          trip.locations.build(FactoryGirl.attributes_for(:location))
        end
      end
    end
  end

  factory :location do
    city { Faker::Address.city }
    country { Faker::Address.country }
    address { [city, country].join(', ') }
    coordinates { [Faker::Address.longitude, Faker::Address.latitude] }
  end
end
