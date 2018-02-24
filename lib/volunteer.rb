class Volunteer
  attr_reader(:name, :id, :project_id)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @project_id = attributes.fetch(:project_id)
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{@name}', '#{@project_id}') RETURNING id;")
    @id = result.first().fetch("id").to_i()
    @project_id = 1.to_i()
  end

  def ==(another_list)
    self.name().==(another_list.name())
  end

  def self.all
    returned_lists = DB.exec("SELECT * FROM volunteers;")
    lists = []
    returned_lists.each() do |list|
      name = list.fetch("name")
      id = list.fetch("id").to_i()
      project_id = list.fetch("project_id").to_i()
      lists.push(Volunteer.new({:name => name, :id => id, :project_id => project_id}))
    end
    lists
  end

  def self.find(id)
    found_list = nil
    Volunteer.all().each() do |list|
      if list.id().==(id)
        found_list = list
      end
    end
    found_list
  end
end
