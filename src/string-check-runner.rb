#!/usr/bin/env ruby
require 'virtus'
require 'fileutils'
require 'open3'
require_relative 'file-parser'
require_relative 'common/dir-helper'

module Onfido
  class StringCheckRunner

    include Virtus.model
    attribute :lang, String
    attribute :platform, String
    attribute :project_path, String
    attribute :branch, String
    attribute :lokalise_project_id, String
    attribute :lokalise_token, String

    TMP_FOLDER = '/tmp/lokalise'

    def run
      DirHelper.create_clean_directory(TMP_FOLDER)
      compareHashes(getProjectStringsAsHash, getLokaliseStringsAsHash)
    end

    private

    def compareHashes(project_hash, lokalise_hash)
      result = []
      extra_keys = lokalise_hash.map { |k, v|
        [k, v] unless project_hash.include? k
      }.compact.to_h
      result << extra_keys
      missing_keys = []
      mismatched_keys = []
      project_hash.each { |k, v|
        if lokalise_hash[k].nil?
          missing_keys << [k, v]
        elsif lokalise_hash[k] != v
          mismatched_keys << [k, v, lokalise_hash[k]]
        end
      }
      result << missing_keys
      result << mismatched_keys
      return result
    end

    def getLokaliseStringsAsHash
      localize_cmd = "lokalise2 file download --format #{file_format}" \
      " -t #{lokalise_token}" \
      " --filter-langs #{lang}" \
      " --directory-prefix #{lang}" \
      " --project-id #{project_id}" \
      " --unzip-to #{TMP_FOLDER}"
      key_response, stderr, status = Open3.capture3(localize_cmd)
      unless status.success?
        raise 'lokalise2 file download command has failed'
      end
      lokalise_hash = FileParser.to_hash("#{TMP_FOLDER}/#{lang}/")
      lokalise_hash.transform_keys { |key|
        key.gsub("::", "_")
      }
    end

    def getProjectStringsAsHash
      project_file = ''
      if platform == 'ios'
        project_file = "#{project_path}/SDK/Assets/#{lang_project}.lproj/Localizable.strings"
      elsif platform == 'android'
        project_file = "#{project_path}/onfido-capture-sdk-core/src/main/res/values#{lang_project}/strings.xml"
      end
      project_hash = FileParser.to_hash(project_file)
      return project_hash

    end

    def file_format
      (platform == 'ios' ? 'strings' : 'xml')
    end

    def lang_project
      tmp_lang = lang.split('_')[0]
      if platform == 'android'
        if tmp_lang == 'en'
          tmp_lang = ''
        else
          tmp_lang = "-#{lang_project}"
        end
      end
      return tmp_lang
    end

    def project_id
      final_branch =  branch != nil ? ":#{branch}" : ''
      "#{lokalise_project_id}#{final_branch}"
    end
  end
end
