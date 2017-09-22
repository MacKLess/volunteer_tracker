require 'sinatra'
require 'sinatra/reloader'
also_reload 'lib/**/*.rb'
require './lib/project'
require './lib/volunteer'
require 'pg'
require 'pry'

DB = PG.connect({:dbname => 'volunteer_tracker'})
