require_relative '../lib/db_client.rb'
require_relative '../lib/db_connection.rb'
require_relative '../lib/db_table.rb'
require_relative '../lib/wine.rb'
require_relative '../lib/scrap_wine_website.rb'

DATABASE = 'webwiner'
DBase.check(DATABASE) # 1. Checa se a basa de dados existe, caso não, cria a base de dados
DBTable.create(DATABASE) # 2. Criar as tabelas caso não existam


links_wine = ScrapWineSite.products_link

links_wine.each do |link|
    wine = Wine.new()
    wine = ScrapWineSite.product_data(link)
    if DBClient.exist?('global_id', wine.global_id, 'wine_site', DATABASE)
        DBClient.update(wine.to_hash,'global_id','wine_site', DATABASE)
    else
        DBClient.add(wine.to_hash, 'wine_site', DATABASE)
    end
end








   

=begin
wine.site_sku ="prod5444"
wine.store = "Wine"
wine.name = "Vinho do Lorenzo"
wine.year = 1999
wine.maker = "Lorenzo"
wine.region = "Colatina"
wine.global_id = "prod5444"
wine.grape = "Roxa"
wine.link = "www.teste.com.br"
wine.price_club = 54.21
wine.price_regular =  50.20
wine.price_sale = 21.40
winehash = wine.to_hash
=end
