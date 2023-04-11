#!/usr/bin/env ruby

# Require the LogParser class
require_relative 'lib/log_parser'

# Check if the correct number of arguments is provided
if ARGV.size != 1
  puts "Usage: ./parser.rb data/webserver.log"
  exit(1)
end

# Get the file path from the command-line argument
file_path = ARGV[0]

# Create a new LogParser instance with the given file path
parser = LogParser.new(file_path)

# Print the list of webpages with most page views
puts "List of webpages with most page views:"
parser.total_page_views.each do |path, count|
  puts "#{path} #{count} visits"
end

# Print the list of webpages with most unique page views
puts "\nList of webpages with most unique page views:"
parser.unique_page_views.each do |path, count|
  puts "#{path} #{count} unique views"
end
