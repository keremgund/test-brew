#!/usr/bin/env ruby
require 'slop'
require 'terminal-table'
require_relative '../src/migrate-keys-runner'
require_relative '../src/common/constants'

options = Slop.parse do |o|
  o.string  '--files-path', '-fp', "Path to language files folder, specify full path", required: true
  o.string  '--platform', '-p', "Platform value, options: #{Onfido::PLATFORMS.join(', ')}", required: true
  o.on      '--help', '-h' do
    puts o
    exit
  end
end

Onfido::MigrateKeysRunner.new(files_path: options[:files_path], platform: options[:platform]).run
