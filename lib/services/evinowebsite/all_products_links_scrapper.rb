# frozen_string_literal: true

require 'selenium-webdriver'
require_relative '../application_service'
require_relative 'connect_url'

module EvinoWebsite
  class AllProductsLinksScrapper < ApplicationService
    def initialize(url)
      @driver = EvinoWebsite::ConnectURL.call(url)
    end

    def call
      close_initial_popup
      expand_page
      scrap_products_links
      @products_links
    end

    private

    def close_initial_popup
      Selenium::WebDriver::Wait.new(timeout: 20)
      @driver.find_element(:xpath, "//div[@class='sc-bZQynM kJvUHU full-height']//i").click
    end

    def expand_page
      button_name = 'Mostrar mais produtos'
      Selenium::WebDriver::Wait.new(timeout: 20)
      while button_name == 'Mostrar mais produtos'
        button = @driver.find_element(:xpath, "//button[@class='sc-bdVaJa jkfVuL']")
        button_name = button.attribute('innerText')
        break if button_name != 'Mostrar mais produtos'
        Selenium::WebDriver::Wait.new(timeout: 20)
        @driver.find_element(:xpath, "//button[@class='sc-bdVaJa jkfVuL']").click
      end
    end

    def scrap_products_links
      @products_links = @driver.find_elements(:xpath, "//div[@class='ProductTile__Content']//a")
      @products_links.map! { |link| link.attribute('href') }
    end
  end
end
