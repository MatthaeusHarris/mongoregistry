#!/usr/bin/env ruby

require 'rubygems'
require 'mongo'
require 'optparse'
require 'pp'

include Mongo

options = {
	:mongohost => "localhost",
	:mongoport => 27017,
	:database => "mongoregistry-test"
}

opt_parser = OptionParser.new do |opt| 
	opt.banner = "Usage: registry.rb COMMAND COLLECTION KEY VALUE [OPTIONS]"
	opt.separator ""
	opt.separator "Commands"
	opt.separator "     set:  set a value"
	opt.separator "     get:  get a value"
	opt.separator "     delete:  delete a value"
	opt.separator "     help:  display this help screen"
	opt.separator ""
	opt.separator "Options"

	opt.on("-a","--authfile", "path to a file with the mongodb information") do |mongoPath|
		options[:mongopath] = mongoPath
		abort("--authfile not implemented yet")
	end

	opt.on("-h", "--host", "hostname of mongodb server (defaults to localhost)") do |mongoHost|
		options[:mongohost] = mongoHost
	end

	opt.on("-p", "--port", "mongodb server port") do |mongoPort| 
		options[:mongoport] = mongoPort
	end

	opt.on("-d", "--database", "mongodb database") do |mongoDB|
		options[:database] = mongoDB
	end

	opt.on("--help", "help") do 
		puts opt_parser
	end
end

opt_parser.parse!

@client = MongoClient.new(options[:mongohost], options[:mongoport])
@db = @client[options[:database]]

if ARGV.length >= 3
	@coll = @db[ARGV[1]]

	case ARGV[0]
	when "get"
		docs = @coll.find("key" => ARGV[2]).to_a
		if (docs.none?)
			abort("No matching documents found.")
		else
			docs.each { |doc| 
				puts doc["value"]
			}
		end


	when "set"
		if ARGV[3]
			@coll.update({"key" => ARGV[2]}, {"key" => ARGV[2], "value" => ARGV[3]}, :upsert=>true)
		else
			abort("Missing value.")
		end

	when "delete"
		@coll.find("key" => ARGV[2]).each do |dead|
			@coll.remove(dead)
		end

	else
		puts opt_parser

	end
else
	puts opt_parser
end

