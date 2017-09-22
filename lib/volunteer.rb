class Volunteer
  attr_accessor(:name, :project_id, :id)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @project_id = attributes.fetch(:project_id)
    @id = attributes.fetch(:id)
  end

  def self.all
    volunteers_list = DB.exec("SELECT * FROM volunteers;")
    volunteers = []
    volunteers_list.each do |volunteer|
      name = volunteer.fetch('name')
      project_id = volunteer.fetch('project_id').to_i
      id = volunteer.fetch('id').to_i
      volunteers.push(Volunteer.new({:name => name, :project_id => project_id, :id => id}))
    end
    volunteers
  end

  def ==(another_volunteer)
    self.name().==(another_volunteer.name()).&(self.project_id().==(another_volunteer.project_id())).&(self.id().==(another_volunteer.id()))
  end

  def save
    volunteer = DB.exec("INSERT INTO volunteers (name, project_id) VALUES ('#{@name}', '#{@project_id}') RETURNING id;")
    @id = volunteer.first.fetch('id').to_i
  end

  def self.find(id)
    Volunteer.all.each do |volunteer|
      if volunteer.id == id
        return volunteer
      end
    end
  end


end
