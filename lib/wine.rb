# frozen_string_literal: true

# require_relative 'db_client' # this class defines a wine object
# Wine: models the wine object
class Wine
  attr_accessor :name, :maker, :year, :grape, :region, :link, :price_club, :price_regular,
                :price_sale, :store_sku, :store, :global_id

  def initialize; 
    @name = nil
    @maker = nil
    @year = nil
    @grape = nil
    @region = nil
    @link = nil
    @price_club = nil
    @price_regular = nil
    @price_sale = nil
    @store_sku = nil
    @store = nil
    @global_id = nil
  end

  def to_hash
    result = instance_variables.map do |attrib|
      [attrib.to_s.delete('@').to_sym, instance_variable_get(attrib)]
    end
    Hash[*result.flatten]
  end
end
