#!/usr/bin/env ruby
require 'logger'

module Onfido

  class DirHelper

    def self.save_file(contents, file_path)
      File.open(file_path, 'w') do |f|
        f.puts contents
      end
    end

    def self.project_root
      File.expand_path("../..", File.dirname(__FILE__))
    end

    def self.resources
      "#{project_root}/resources"
    end

    def self.create_clean_directory_in_path(name, path)
      directory_to_create = File.expand_path(name, path)
      create_clean_directory(directory_to_create)
      return directory_to_create
    end

    def self.create_clean_directory(directory)
      if File.directory?(directory)
        FileUtils.rm_rf(directory)
      end
      FileUtils.mkdir_p(directory)
    end
  end
end
