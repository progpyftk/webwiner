# frozen_string_literal: true

# require_relative 'db_client' # this class defines a wine object
class Wine
  attr_accessor :name, :maker, :year, :grape, :region, :link, :price_club, :price_regular,
                :price_sale, :site_sku, :store, :global_id

  def to_hash
    result = instance_variables.map do |attrib|
      [attrib.to_s.delete('@').to_sym, instance_variable_get(attrib)]
    end
    Hash[*result.flatten]
  end
end
