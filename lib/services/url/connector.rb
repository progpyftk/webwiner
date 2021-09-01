# frozen_string_literal: true

require_relative '../application_service'
require 'faraday'
require 'nokogiri'

module URL
  class Connector < ApplicationService
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def call
      Faraday.get(url)
      # TODO: tratar os retornos de resp
    end
  end
end
