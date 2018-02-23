class Project
  attr_reader(:title, :id)

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
  end

  def ==(another_list)
    self.title().==(another_list.title())
  end

  def self.all
    returned_lists = DB.exec("SELECT * FROM projects;")
    lists = []
    returned_lists.each() do |list|
      title = list.fetch("title")
      id = list.fetch("id").to_i()
      lists.push(Project.new({:title => title, :id => id}))
    end
    lists
  end

  def self.find(id)
    found_list = nil
    Project.all().each() do |list|
      if list.id().==(id)
        found_list = list
      end
    end
    found_list
  end

  def volunteers
    list_volunteers = []
    volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id()};")
    volunteers.each() do |volunteer|
      name = volunteer.fetch("name")
      project_id = volunteer.fetch("project_id").to_i()
      id = volunteer.fetch("id").to_i()
      list_volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
    end
    list_volunteers
  end

  def update(attributes)
     @title = attributes.fetch(:title)
     @id = self.id()
     DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
   end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{self.id()};")
  end

  def self.find(id)
    found_list = nil
    Project.all().each() do |project|
      if project.id().==(id)
        found_list = list
      end
    end
    found_list
  end

end
