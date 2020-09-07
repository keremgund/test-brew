#!/usr/bin/env ruby

require 'json'
require 'fileutils'
require 'nokogiri'
require_relative 'common/constants'

module Onfido

  class FileParser

    ##
    # This class reads strings file and transforms each  "key"="value" line to hash key/value and returns hash
    # e.g "blur_detection_subtitle" = "Make sure your \"dummy string\" details are clear and unobstructed" should be extracted to
    # string_map["blur_detection_subtitle"] = "Make sure your \"dummy string\" details are clear and unobstructed"
    ##

    def self.to_hash(file_path)
      string_map = {}
      if File.directory?(file_path)
        Dir.glob("#{file_path}*").each { |file|
          convert(file, string_map)
        }
      else
        convert(file_path, string_map)
      end
      string_map
    end

    private
     def self.add_entry_to_hash(line, string_map)
       if pair_match = line.match(LOCALIZE_RESULTS_REGEX_IOS)
         translation_key = pair_match[1]
         translation_value = pair_match[2]
         string_map[translation_key] = translation_value
       end
     end

     def self.convert(file, string_map)
       if File.extname(file) == '.xml'
          xml = Nokogiri::XML(File.open(file))
          list = xml.xpath("//string")
          for node in list do
            string_map[node['name']] = node.text
          end
       else
         File.readlines(file).each do |line|
           add_entry_to_hash(line, string_map)
         end
       end
       string_map
     end
  end
end
