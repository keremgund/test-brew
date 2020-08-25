#!/usr/bin/env ruby

require 'virtus'

module Onfido

  class LocalisationKey
    include Virtus.model

    attribute :key_name, String
    attribute :translation_value, String
    attribute :language_iso_code, String

    def to_s
      "#{key_name} - #{language_iso_code}"
    end
  end
end
