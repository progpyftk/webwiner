require_relative '../application_service'
require 'selenium-webdriver'
# Evino module
module URL

  # returns the Selenium driver for a received link
  class SeleniumConnector < ApplicationService
    def initialize(url)
      @url = url
    end

    def call
      connect_url
      @driver
    end

    private

    def connect_url
      @driver = Selenium::WebDriver.for :firefox
      @driver.get @url
    end
  end
end
