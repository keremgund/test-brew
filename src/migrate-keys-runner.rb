#!/usr/bin/env ruby

require 'terminal-table'
require 'virtus'
require 'json'
require 'open3'

require_relative 'common/constants'
require_relative 'common/dir-helper'
require_relative 'common/logger'
require_relative 'common/execution-steps'

module Onfido

  class MigrateKeysRunner
    include Virtus.model
    attribute :files_path, String
    attribute :platform, String

    def run
      steps = ["Retrieve keys to update", 'Retrieve files to update',
              'Update files']
      execution_steps = ExecutionSteps.new('Steps', steps)

      begin
        keys_to_update_dict = retrieve_keys_to_update
        puts Terminal::Table.new(title: 'Keys to be updated', headings: ['Old key', 'New key'], rows: keys_to_update_dict)
        execution_steps.success
        file_list = retrieve_files_to_update
        file_dict = file_list.map { |f| ['File', f] }
        puts Terminal::Table.new(title: 'File List', rows: file_dict)
        execution_steps.success
        file_list.each { |file|
          update_file(file, keys_to_update_dict)
        }
        execution_steps.success
      rescue Exception => exception
        Logger.error(exception.message)
        execution_steps.failed
        raise exception
      ensure
        execution_steps.print
      end
    end

    private

      def retrieve_keys_to_update
        keys_file_path = "#{DirHelper.resources}/keys-to-update.json"
        keys_file_content = File.read(keys_file_path)
        keys_to_update_dict = JSON.parse(keys_file_content)
      end

      def retrieve_files_to_update
        files = []
        Dir.glob("#{files_path}/**/*.#{string_file_extension}").each { |file|
          files.push(file)
        }
        return files
      end

      def string_file_extension
        if platform == 'ios'
          return 'strings'
        elsif platform == 'android'
          return 'xml'
        end
      end

      def update_file(file, key_dict)
        content = File.read(file)
        content_changed = false
        key_dict.each do | old_key, new_key |
          File.readlines(file).each do |line|
            if pair_match = line.match(regex_for_string_file)
              translation_key = pair_match[1]
              if translation_key == old_key
                content_changed = true
                entry = build_and_return_string_entry(new_key, pair_match[2])
                content = content.sub(line, entry)
                Logger.success("Updated #{translation_key} with #{new_key}.")
                break
              end
            end
          end
        end
        if content_changed
          File.open(file, "w") {|file| file.puts content }
        end
      end

      def regex_for_string_file
        if platform == 'ios'
          return LOCALIZE_RESULTS_REGEX_IOS
        elsif platform == 'android'
          return LOCALIZE_RESULTS_REGEX_ANDROID
        end
      end

      def build_and_return_string_entry(key, value)
        if platform == 'ios'
          return "\"#{key}\" = \"#{value}\";\n"
        elsif platform == 'android'
          return "<string name=\"#{key}\">#{value}</string>\n"
        end
      end
    end
  end
