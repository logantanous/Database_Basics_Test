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
  erb(:index)
end

post("/project_success") do
  title = params.fetch("title")
  @projects = Project.new({:title => title, :id => nil})
  @projects.save()
  erb(:project_success)
end

get("/:id") do
  @projects = Project.find(params.fetch("id").to_i())
  erb(:project)
end


get("/:id/edit") do
  @projects = Project.find(params.fetch("id").to_i())
  erb(:edit)
end

patch("/:id/edit") do
  title = params.fetch("title")
  @projects = Project.find(params.fetch("id").to_i())
  @projects.update({:title => title})
  erb(:project_success)
end

# get("/project_success") do
#   title = params.fetch("title")
#   @list = Project.find(title)
#   @task = Project.new({:title => title, :list_id => list_id})
#   erb(:index)
# end
#
# get("/lists/new") do
#   erb(:list_form)
# end
#
# get("/lists") do
#  @lists = List.all()
#  erb(:lists)
# end
#
# post("/lists") do
#   name = params.fetch("name")
#   list = List.new({:name => name, :id => nil})
#   list.save()
#   erb(:success)
# end
#
# get("/lists/:id") do
#   @list = List.find(params.fetch("id").to_i())
#   erb(:list)
# end
#
# post("/tasks") do
#   description = params.fetch("description")
#   list_id = params.fetch("list_id").to_i()
#   @list = List.find(list_id)
#   @task = Task.new({:description => description, :list_id => list_id})
#   @task.save()
#   erb(:task_success)
# end
