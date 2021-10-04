# frozen_string_literal: true

require 'selenium-webdriver'
require_relative '../application_service'
require_relative '../url/selenium_connector'
require 'nokogiri'
require 'faraday'

module EvinoWebsite
  # expande a pagina da evino e retorna um doc da pagina expandida
  class PageExpander < ApplicationService
    attr_reader :number_of_clicks

    def initialize(url)
      @driver = URL::SeleniumConnector.call(url)
      @number_of_clicks = 0
    end

    def call
      close_initial_popup
      expand_page
      Selenium::WebDriver::Wait.new(timeout: 5)
      puts @driver.page_source.class
      page_doc = Nokogiri::HTML(@driver.page_source)
      @driver.close
      page_doc
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
        @number_of_clicks += 1
        button = @driver.find_element(:xpath, "//button[@class='sc-bdVaJa jkfVuL']")
        button_name = button.attribute('innerText')
        break if button_name != 'Mostrar mais produtos'

        Selenium::WebDriver::Wait.new(timeout: 20)
        @driver.find_element(:xpath, "//button[@class='sc-bdVaJa jkfVuL']").click
      end
    end
  end
end
