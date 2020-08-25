#!/usr/bin/env ruby
require 'slop'
require 'terminal-table'
require_relative '../src/string-check-runner'
require_relative '../src/common/constants'

options = Slop.parse do |o|
  o.string  '--lang', '-l', "Language code, options: #{Onfido::LANGUAGES.join(', ')}", required: true
  o.string  '--platform', '-p', "Platform value, options: #{Onfido::PLATFORMS.join(', ')}", required: true
  o.string  '--lokalise-token', '-lt', 'Lokalise token to access strings', required: true
  o.string  '--lokalise-project-id', '-lpi', 'Lokalise project id', required: true
  o.string  '--project-path', '-pp', 'Path to project root', required: true
  o.string  '--branch', '-lb', 'Lokalise branch name', required: true
  o.on      '--help', '-h' do
    puts o
    exit
  end
end

result = Onfido::StringCheckRunner.new(lang: options[:lang], platform: options[:platform],
  project_path: options[:project_path], branch: options[:branch], lokalise_project_id: options[:lokalise_project_id],
  lokalise_token: options[:lokalise_token]).run

puts Terminal::Table.new title: 'Extra keys in lokalise', rows: result[0]
puts Terminal::Table.new title: 'Missing keys in lokalise', rows: result[1]
puts Terminal::Table.new title: 'Mismatched translation values', headings: ['key', 'Value in Project', 'Value in Lokalise'], rows: result[2]
