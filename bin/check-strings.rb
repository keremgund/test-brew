#!/usr/bin/env ruby
require 'slop'

require_relative '../src/string-check-runner'

options = Slop.parse do |o|
  o.string  '--lang', '-l', 'Language code', required: true
  o.string  '--platform', '-p', 'Platform value, can be either ios or android', required: true
  o.string  '--lokalise-token', '-lt', 'Lokalise token to access strings', required: true
  o.string  '--lokalise-project-id', '-lpi', 'Lokalise project id', required: true
  o.string  '--project-path', '-pp', 'Path to project root', required: true
  o.string  '--branch', '-lb', 'Lokalise branch name', required: true
  o.on      '--help', '-h' do
    puts o
    exit
  end
end

Onfido::StringCheckRunner.new(lang: options[:lang], platform: options[:platform],
  project_path: options[:project_path], branch: options[:branch], lokalise_project_id: options[:lokalise_project_id],
  lokalise_token: options[:lokalise_token]).run
