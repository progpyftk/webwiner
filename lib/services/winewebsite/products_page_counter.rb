require_relative '../application_service'

module Winewebsite
    
    class ProductsPageCounter < ApplicationService
        def initialize(page_doc)
            puts 'estou aqui'
            @page_doc = page_doc
        end

        def call
            number_of_products = @page_doc.xpath('//*[@class="row ProductDisplay-name"]//a//@href').length
            number_of_products
        end

    end

end

