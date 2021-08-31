# frozen_string_literal: true

require_relative '../application_service'
require_relative 'connector'
require 'nokogiri'

module URL
  class Parser < ApplicationService
    attr_reader :response

    def initialize(url)
      @response = Connector.call(url)
    end

    def call
      doc = Nokogiri::HTML response.body
      doc
    end
    
  end
end
