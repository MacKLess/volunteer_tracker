require 'sinatra'
require 'sinatra/reloader'
also_reload 'lib/**/*.rb'
require './lib/project'
require './lib/volunteer'
require 'pg'
require 'pry'

DB = PG.connect({:dbname => 'volunteer_tracker'})

#this accesses the mainpage
get('/') do
  @projects = Project.all
  erb(:index)
end

#this allows you to add a project to the mainpage
post('/') do
  title = params.fetch('title')
  project = Project.new({:title => title, :id => nil})
  project.save
  @projects = Project.all
  erb(:index)
end

#this is supposed to list volunteers assigned to a project --> broken?
get('/project/:id') do
  @project = Project.find(params.fetch(:id).to_i)
  erb(:project_detail)
end

#this creates volunteers by assigning them to the project.
post('/project/:id/volunteer') do
  @project = Project.find(params.fetch(:id).to_i)
  name = params.fetch('name')
  @volunteer = Volunteer.new({:name => name, :project_id => @project.id, :id => nil})
  @volunteer.save
  erb(:project_detail)
end

get('/project/:id/edit') do
  @project = Project.find(params.fetch(:id).to_i)
  erb(:project_update)
end

#this updates the project name
patch('/project/:id/edit') do
  @project = Project.find(params.fetch(:id).to_i)
  title_change = params.fetch(:title)
  @project.update({:title => title_change})
  erb(:project_detail)
end

#this deletes a project
delete('/project/:id/edit') do
  @project = Project.find(params.fetch(:id).to_i)
  @project.delete
  @projects = Project.all
  erb(:index)
end

get('/volunteer/:id') do
  @volunteer = Volunteer.find(params.fetch(:id).to_i)
  @project = Project.find(@volunteer.project_id)
  erb(:volunteer_detail)
end
