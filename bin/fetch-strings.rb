#!/usr/bin/env ruby
require 'slop'

require_relative '../src/localisation-file-updater'
require_relative '../src/common/constants'

options = Slop.parse do |o|
  o.string  '--tag',   '-t',  'Tag name that you want to fetch from lokalise', required: true
  o.string  '--lokalise-project-id', '-lpi',  'Lokalise project id', required: true
  o.string  '--lokalise-token',   '-lt',  'Lokalise token to access strings', required: true
  o.string  '--platform', '-p', "Platform value, options: #{Onfido::PLATFORMS.join(', ')}", required: true
  o.string  '--project-path', '-pp', 'Path to project root', required: true
  o.on      '--help', '-h' do
    puts o
    exit
  end
end

Onfido::LocalisationFileUpdater.new(tag: options[:tag],
                    lokalise_project_id: options[:lokalise_project_id],
                         lokalise_token: options[:lokalise_token],
                               platform: options[:platform],
                           project_path: options[:project_path]).run
