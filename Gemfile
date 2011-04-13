# encoding: UTF-8

# Copyright 2011 innoQ Deutschland GmbH
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source 'http://rubygems.org'

# TODO: The following dependencies could be included by the "gemspec" command.
# There is only one problem: gemspec puts the dependencies automatically to a
# group (:development by default). This is not what we need. 
gem 'rails', '3.0.6'

gem 'will_paginate', '3.0.pre2'
gem 'authlogic'
gem 'cancan'
gem 'iq_rdf', '~> 0.0.14'
gem 'json'

# Hotfix for the problem of engine/plugin helpers not being mixed in.
# https://rails.lighthouseapp.com/projects/8994/tickets/1905-apphelpers-within-plugin-not-being-mixed-in
# http://github.com/drogus/rails_helpers_fix
gem 'rails_helpers_fix'

group :development do
  gem 'awesome_print'
end

group :development, :test do
  platforms :ruby do
    gem 'mysql' # AR Bug
    gem 'mysql2'
  end
  platforms :jruby do
    gem 'activerecord-jdbcmysql-adapter'
  end
end

group :test do
  gem 'nokogiri', '1.4.3.1'
  gem 'capybara'
  # gem 'capybara-envjs'
  gem 'database_cleaner', '0.6.0.rc.3'
  gem 'launchy'    # So you can do Then show me the page
  gem 'factory_girl_rails'
end

group :production, :production_internal do
  platforms :ruby do
    gem 'sqlite3-ruby', :require => 'sqlite3'
  end
  
  platforms :jruby do
    gem 'activerecord-oracle_enhanced-adapter'
  end
end
