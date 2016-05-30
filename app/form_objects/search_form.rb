class SearchForm
  include ActiveModel::Model
  attr_accessor :keywords

  def self.model_name
    ActiveModel::Name.new(self, nil, 'SearchForm')
  end

  def self.search(params)
    new(params).search
  end

  def search
    clean_attributes
    Trip.where(locations_list: /.*#{keywords}.*/i)
  end

  def clean_attributes
    self.instance_variables.each do |var|
      value = instance_variable_get(var)
      value.strip! if value.kind_of?(String) && value.present?
    end
  end
end