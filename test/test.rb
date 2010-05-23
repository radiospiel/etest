#!/usr/bin/env ruby
DIRNAME = File.expand_path File.dirname(__FILE__)
Dir.chdir(DIRNAME)

ETEST_TEST=true

#
# initialize the gem
require '../init'

require "#{DIRNAME}/etest_assertions.rb"
require "#{DIRNAME}/etest_string.rb"

require 'logger'
require 'rubygems'
require 'ruby-debug'

LOGFILE = "log/test.log"
SQLITE_FILE = ":memory:"

#
# -- set up fake rails ------------------------------------------------

RAILS_ENV="test"
RAILS_ROOT="#{DIRNAME}"

if !defined?(RAILS_DEFAULT_LOGGER)
  require "fileutils"
  FileUtils.mkdir_p File.dirname(LOGFILE)
  RAILS_DEFAULT_LOGGER = Logger.new(LOGFILE)
  RAILS_DEFAULT_LOGGER.level = Logger::DEBUG
end

#
# -- set up active record for tests -----------------------------------

if defined?(ActiveRecord::Base) && !ActiveRecord::Base.connection
  ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER
  FileUtils.mkdir_p File.dirname(SQLITE_FILE) unless SQLITE_FILE == ":memory:"
  ActiveRecord::Base.establish_connection :adapter => "sqlite3",
    :database => SQLITE_FILE
end

# ---------------------------------------------------------------------

module Fixnum::Etest
  def test_success
    $etests_did_run = true
    assert true
  end
end

$etests_did_run = false
Etest.reload
Etest.autorun

unless $etests_did_run
  STDERR.puts "Something's wrong with etests :(" 
  exit 1
end

STDERR.puts "===== Reloading and rerunning one test"

$etests_did_run = false

Fixnum.etest

unless $etests_did_run
  STDERR.puts "Something's wrong with etests :(" 
  exit 1
end
