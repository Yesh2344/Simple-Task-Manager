require 'json'

class TaskStorage
  def initialize(file_path)
    @file_path = file_path
  end

  def load_tasks
    if File.exist?(@file_path)
      json_data = File.read(@file_path)
      tasks_data = JSON.parse(json_data)
      tasks = tasks_data.map do |task_data|
        task = Task.new(task_data['description'])
        task.completed = task_data['completed']
        task
      end
      tasks
    else
      []
    end
  rescue JSON::ParserError => e
    puts "Error parsing tasks file.  Creating a new one.".red
    return [] # Return an empty array to start fresh
  end

  def save_tasks(tasks)
    tasks_data = tasks.map do |task|
      { 'description' => task.description, 'completed' => task.completed }
    end
    json_data = JSON.pretty_generate(tasks_data)
    File.write(@file_path, json_data)
  end
end
