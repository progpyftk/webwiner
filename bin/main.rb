require_relative '../lib/wine.rb'
require_relative '../lib/db_connection.rb'



wine = Wine.new()

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


WineDB.check_db
wine.add