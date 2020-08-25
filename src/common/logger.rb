#!/usr/bin/env ruby
require 'logger'

module Onfido

  class Logger

    def self.error(message)
      puts("❌: #{message}")
    end

    def self.warning(message)
      puts("⚠️: #{message}")
    end

    def self.info(message)
      puts("ℹ️: #{message}")
    end

    def self.debug(message)
      puts(message)
    end
  end
end
