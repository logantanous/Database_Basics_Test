require("sinatra")
require("sinatra/reloader")
require("./lib/project")
require("./lib/volunteer")
also_reload("lib/**/*.rb")
require("pg")
require("pry")

# # Important Note: When app.rb runs, it is written to use the volunteer_tracker database. In order for our integration specs to pass, we need to use the volunteer_tracker_test database. This can be accomplished by temporarily adding DB = PG.connect({:dbname => "to_do_test"}) to our app.rb file (which will need to be changed back to to_do after testing).

DB = PG.connect({:dbname => "volunteer_tracker_test"})

get("/") do
  @projects = Project.all()
  @volunteers = Volunteer.all()
  erb(:index)
end

post("/project_success") do
  title = params.fetch("title")
  @projects = Project.new({:title => title, :id => nil})
  @projects.save()
  erb(:project_success)
end

post("/volunteer_success") do
  name = params.fetch("name")
  @volunteers = Volunteer.new({:name => name, :project_id => nil, :id => nil})
  @volunteers.save()
  erb(:volunteer_success)
end

get("/projects/:id") do
  @projects = Project.find(params.fetch("id").to_i())
  erb(:project)
end

get("/volunteers/:id") do
  @volunteers = Volunteer.find(params.fetch("id").to_i())
  erb(:volunteer)
end


get("/projects/:id/edit") do
  @projects = Project.find(params.fetch("id").to_i())
  erb(:edit)
end

patch("/projects/:id/edit") do
  title = params.fetch("title")
  @projects = Project.find(params.fetch("id").to_i())
  @projects.update({:title => title})
  erb(:project_success)
end

delete("/projects/:id/edit") do
  @project = Project.find(params.fetch("id").to_i())
  @project.delete()
  @projects = Project.all()
  erb(:index)
end
