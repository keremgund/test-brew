#!/usr/bin/env ruby

require 'terminal-table'
require 'virtus'
require 'json'
require 'open3'

require_relative 'common/constants'
require_relative 'common/logger'
require_relative 'common/execution-steps'
require_relative 'models/localisation-key'

module Onfido

  class LocalisationFileUpdater
    include Virtus.model

    attribute :tag, String
    attribute :lokalise_project_id, String
    attribute :lokalise_token, String
    attribute :platform, String
    attribute :project_path, String

    def run
      steps = ["List strings on lokalise with #{tag} tag for #{platform}", 'Retrive string translations from lokalise',
              'Update strings on project files']
      execution_steps = ExecutionSteps.new('Steps', steps)

      begin
        key_id_list = get_key_id_list
        execution_steps.success
        key_array = get_key_translations(key_id_list)
        execution_steps.success
        key_array.each { |key|
          update_key(key)
        }
        execution_steps.success
        Logger.success('Steps completed.')
      rescue Exception => exception
        Logger.error(exception.message)
        execution_steps.failed
        raise exception
      ensure
        execution_steps.print
      end
    end

    private

      def get_key_translations(key_id_list)
        response =  key_id_list.flat_map { |key_id|
          key_detail_dict = get_key_detail_dict(key_id)
          key_name = key_detail_dict['key']['key_name'][platform]
          localisation_keys =  key_detail_dict['key']['translations'].map { |key_translation|
             LocalisationKey.new(key_name: key_name,translation_value: key_translation['translation'] ,language_iso_code: key_translation['language_iso'])
          }
        }
        return response
      end

      def get_key_detail_dict(key_id)
        key_response, stderr, status = Open3.capture3("lokalise2 key retrieve \
          --key-id #{key_id} \
          --project-id #{lokalise_project_id} \
          --token #{lokalise_token}")

        unless status.success?
          raise 'lokalise2 key list command has failed'
        end

        JSON.parse(key_response)
      end

      def get_key_id_list
        body, stderr, status = Open3.capture3("lokalise2 key list \
          --filter-tags '#{tag}' \
          --filter-platforms #{platform} \
          --project-id #{lokalise_project_id} \
          --token #{lokalise_token}")

        unless status.success?
          raise 'lokalise2 key list command has failed'
        end
        dictionary = JSON.parse(body)
        id_list = dictionary['keys'].map { |item| item['key_id'] }
      end

      def update_key(key)
        Logger.info("Updating key: #{key}")
        lang_code = get_lang_code(key)
        new_key = key.key_name.gsub("::", "_")
        if platform == 'ios'
          entry = "\"#{new_key}\" = \"#{key.translation_value}\";\n"
          add_substitute_for_ios(entry, get_strings_file(lang_code), key)
        else
          ##TODO handle android case here
        end
      end

      def get_lang_code(key)
        key.language_iso_code.include?('_') ? key.language_iso_code.split("_").first : key.language_iso_code
      end

      def get_strings_file(lang_code)
        if platform == 'ios'
          return "#{project_path}/SDK/Assets/#{lang_code}.lproj/Localizable.strings"
        else
          ##TODO handle android case here
        end
      end

      def add_substitute_for_ios(entry, file, key)
        content = File.read(file)
        existing_key = false
        File.readlines(file).each do |line|
          if pair_match = line.match(LOCALIZE_RESULTS_REGEX_IOS)
            translation_key = pair_match[1]
            if translation_key == key.key_name
              content = content.sub(line, entry)
              existing_key = true
              break
            end
          end
        end
        unless existing_key
          content += entry
        end
        File.open(file, "w") {|file| file.puts content }
      end
    end
  end
