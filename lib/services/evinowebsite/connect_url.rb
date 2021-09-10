# frozen_string_literal: true

require_relative '../application_service'
require 'selenium-webdriver'

module EvinoWebsite
  class ConnectURL < ApplicationService
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
