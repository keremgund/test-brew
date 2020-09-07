#!/usr/bin/env ruby

module Onfido

  LOCALIZE_RESULTS_REGEX_IOS = /"(.+)"\s*=\s*"(.+)"/
  LOCALIZE_RESULTS_REGEX_ANDROID = /<string name=\s*\"(.+)\"\s*>(.+)<\/string>/

  PLATFORMS = ['ios', 'android', 'web']
  LANGUAGES = ['en_US', 'de_DE', 'es_ES', 'fr_FR']

end
