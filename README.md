mongoregistry
=============

A very simple command-line key/value store based on mongoDb.

Usage: registry.rb COMMAND COLLECTION KEY VALUE [OPTIONS]

Commands
     set:  set a value
     get:  get a value
     delete:  delete a value
     help:  display this help screen

Options
    -a, --authfile                   path to a file with the mongodb information (currently unimplemented)
    -h, --host                       hostname of mongodb server (defaults to localhost)
    -p, --port                       mongodb server port
    -d, --database                   mongodb database
        --help                       help
