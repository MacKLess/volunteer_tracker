require 'sinatra'
require 'sinatra/reloader'
also_reload 'lib/**/*.rb'
require './lib/project'
require './lib/volunteer'
require 'pg'
require 'pry'

DB = PG.connect({:dbname => 'volunteer_tracker'})

get('/') do
  @projects = Project.all
  erb(:index)
end

post('/') do
  title = params.fetch('title')
  project = Project.new({:title => title, :id => nil})
  project.save
  @projects = Project.all
  erb(:index)
end

get('/project/:id') do
  @project = Project.find(params.fetch(:id).to_i)
  @volunteers = Volunteer.find(params.fetch(:id).to_i)
  erb(:project_detail)
end

get('/project/:id/edit') do
  @project = Project.find(params.fetch(:id).to_i)
  erb(:project_update)
end

post('/project/:id/edit') do
  @project = Project.find(params.fetch(:id).to_i)
  title_change = params.fetch(:title)
  @project.update({:title => title_change})
  erb(:project_detail)
end

delete('/project/:id/edit') do
  @project = Project.find(params.fetch(:id).to_i)
  @project.delete
  @projects = Project.all
  erb(:index)
end

post('/project/:id/volunteer') do
  @project = Project.find(params.fetch(:id).to_i)
  name = params.fetch('name')
  @volunteer = Volunteer.new({:name => name, :project_id => @project.id, :id => nil})
  @volunteer.save
  erb(:project_detail)
end

get('/volunteer/:id') do
  @volunteer = Volunteer.find(params.fetch(:id).to_i)
  @projects = Project.find(params.fetch(:project_id).to_i)
  erb(:volunteer_detail)
end
