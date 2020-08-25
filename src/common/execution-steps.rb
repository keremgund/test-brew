#!/usr/bin/env ruby

require 'terminal-table'
require 'logger'

module Onfido

  class ExecutionSteps

    #
    # @parameter [Array<String>] steps to be executed
    # @parameter [String] a banner to print
    #
    def initialize(title, steps)
      _2dSteps = []
      steps.each do |step|
        _2dSteps.push([step, nil])
      end
      @title = title
      @steps = _2dSteps
      @current_step_index = 0
    end

    def print_next_step
      Logger.info(@steps[@current_step_index][0])
    end

    def skip
      @steps[@current_step_index][1] = "⏩"
      @current_step_index += 1
    end

    def success
      @steps[@current_step_index][1] = "✅"
      @current_step_index += 1
    end

    def failed
      for index in (@current_step_index...@steps.length)
        @steps[index][1] = "💥"
      end
    end

    def print
      puts Terminal::Table.new :title => @title, :rows => @steps
    end
  end
end
