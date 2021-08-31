require_relative '../application_service'

module Winewebsite

    class PageProductsLinksCatcher < ApplicationService

        attr_reader :page_doc

        def initialize(page_doc)
            @page_doc = page_doc
        end

        def call
            page_links = page_doc.xpath('//*[@class="row ProductDisplay-name"]//a//@href').map(&:text)
            page_links.map! { |each_link| "https://www.wine.com.br" + each_link }
            page_links
        end

        
      
    end

end