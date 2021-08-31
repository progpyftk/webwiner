require_relative '../application_service'
require_relative '../wine'

module Winewebsite

    class ProductPageScrapper < ApplicationService

        def initialize(page_doc, link)
            @wine = Wine.new()
            @wine.link = link
            @wine.store = 'Wine'
        end

        def call 
            @wine
        end

        private
        def scrap_product_date
            self.store_sku
            self.global_id
            self.name
            self.grape_region_year_maker
            self.wine_prices


        end

        def store_sku
            @wine.store_sku = link.scan(/(?=prod)(.*)(?=.html)/).flatten[0]
        end

        def global_id
            @wine.site_sku = link.scan(/(?=prod)(.*)(?=.html)/).flatten[0]
        end

        def name
            name_xpath = '//h1[@class="PageHeader-title w-title--4  text-center "]'
            @wine.name = doc.xpath(name_xpath).first.text unless doc.xpath(name_xpath).first.nil?
        end

        def grape_region_year_maker
            index = 0
            while index < doc.xpath(WINE_DATA_FEATURE_NAME).length
                next if doc.xpath(WINE_DATA_FEATURE_VALUE)[index].nil?

                if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == 'Uva'
                    @wine.grape = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text
                end
                if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == 'Vinícola'
                    @wine.maker = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text
                end
                if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == 'Safra'
                    @wine.year = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text.to_i
                end
                if doc.xpath(WINE_DATA_FEATURE_NAME)[index].text == 'País - Região'
                    @wine.region = doc.xpath(WINE_DATA_FEATURE_VALUE)[index].text
                end
                index += 1
            end
            year = @wine.name.scan(/\d{4}/)
            @wine.year = year if @wine.year.nil? && !year.nil?
        end

        def wine_prices(doc)
            if doc.xpath('//price-box')[0]
            @wine.price_club = doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[0].to_f
            @wine.price_regular = doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[1].to_f
            @wine.price_sale = doc.xpath('//price-box').attr(':product').text.scan(/\d+\.\d+/)[2].to_f
            else
            @wine.price_club = nil
            @wine.price_regular = nil
            @wine.price_sale = nil
            end
        end
    end
end
