require_relative 'wine'
require_relative 'winestore_website'

class WineStoreWinePage
  WINE_DATA_FEATURE_NAME = '//dt[@class="w-caption"]' # xpath to find the wine features name at its main page
  WINE_DATA_FEATURE_VALUE = '//dd[@class="w-paragraph"]' # xpath to find the wine features value at its main page
  WINE_NAME_XPATH = '//h1[@class="PageHeader-title w-title--4  text-center "]' # xpath to find the wine's name at its main page

  def initialize(link)
    @wine = Wine.new
    @wine.link = link
  end

  # # return a wine object for each link
  def product_data
    link = @wine.link
    res = Faraday.get(link) # request to the next page
    doc = Nokogiri::HTML res.body # parse the page html
    # getting the product store's sku using regex at wine link string
    @wine.site_sku = link.scan(/(?=prod)(.*)(?=.html)/).flatten[0]
    @wine.global_id = link.scan(/(?=prod)(.*)(?=.html)/).flatten[0]
    @wine.name = doc.xpath(WINE_NAME_XPATH).first.text unless doc.xpath(WINE_NAME_XPATH).first.nil?
    # getting the grape, maker, year and regiom
    wine_grape_region_year_maker(doc)
    # getting club price, sale price and regular price
    wine_prices(doc)
    @wine
  end

  def wine_grape_region_year_maker(doc)
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
