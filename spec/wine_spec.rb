require_relative '../lib/wine'

RSpec.describe Wine do
    wine = Wine.new

    it 'numero de propriedades' do
        puts wine.instance_variables.class
        expect(wine.instance_variables.length).to eq(12)
    end

    it 'creates an empty wine' do        
        expect(wine.name).to eq(nil)
        expect(wine.maker).to eq(nil)
        expect(wine.year).to eq(nil)
        expect(wine.grape).to eq(nil)
        expect(wine.region).to eq(nil)
        expect(wine.link).to eq(nil)
        expect(wine.price_club).to eq(nil)
        expect(wine.price_regular).to eq(nil)
        expect(wine.price_sale).to eq(nil)
        expect(wine.store_sku).to eq(nil)
        expect(wine.store).to eq(nil)
        expect(wine.global_id).to eq(nil)
    end

    it 'attributing values to instance variables' do
        wine.name = 'Nome do vinho'
        wine.maker = 'Nome do fabricante'
        wine.year = 1990
        wine.grape = 'Nome das uvas'
        wine.region = "Regiao do vinho"
        wine.link = "link do vinho"
        wine.price_club = 10.00
        wine.price_regular = 11.00
        wine.price_sale = 13.00
        wine.store_sku = 14.00
        wine.store = "Nome da loja"
        wine.global_id = "Sku global"
        expect(wine.name).to eq('Nome do vinho')
        expect(wine.maker).to eq('Nome do fabricante')
        expect(wine.year).to eq(1990)
        expect(wine.grape).to eq('Nome das uvas')
        expect(wine.region).to eq("Regiao do vinho")
        expect(wine.link).to eq("link do vinho")
        expect(wine.price_club).to eq(10.00)
        expect(wine.price_regular).to eq(11.00)
        expect(wine.price_sale).to eq(13.00)
        expect(wine.store_sku).to eq(14.00)
        expect(wine.store).to eq("Nome da loja")
        expect(wine.global_id).to eq("Sku global")
    end

    wine_dict = {
        name: 'Nome do vinho',
        maker: 'Nome do fabricante',
        year: 1990,
        grape: 'Nome das uvas',
        region: "Regiao do vinho",
        link: "link do vinho",
        price_club: 10.00,
        price_regular: 11.00,
        price_sale: 13.00,
        store_sku: 14.00,
        store: "Nome da loja",
        global_id: "Sku global"}
    
    it 'return a dict' do
        expect(wine.to_hash).to eq(wine_dict)
    end
end
