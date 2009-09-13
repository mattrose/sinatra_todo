class Todo
  PriorityContentRegex = /^([\S.]) ([^#]*)/

  attr_accessor :content
  attr_accessor :priority
  attr_accessor :tags

  def active?
    !self.priority.match(/[0X]/)
  end

  def has_tag?(tag)
    tags.include?(tag.downcase)
  end
  
  def self.all
    todos = []
    read_from_disk.each do |line|
      todos << new_from_file_format(line)
    end
    todos
  end

  def self.active
    todos = []
    read_from_disk.each do |line|
      todo = new_from_file_format(line)
      todos << todo if todo.active?
    end
    todos
  end

  def self.find_by_priority(priority)
    todos = []
    read_from_disk.each do |line|
      todo = new_from_file_format(line)
      todos << todo if priority == todo.priority
    end
    todos
  end
  
  def self.find_by_tag(tag)
    todos = []
    read_from_disk.each do |line|
      todo = new_from_file_format(line)
      todos << todo if todo.has_tag?(tag)
    end
    todos
  end
  
  private

  def self.find_tags(line)
    line.
      scan(/#\w+/). # Hash words
      collect {|w| w.sub(/#/,'').downcase }. # Remove hash (#)
      uniq
  end
  
  def self.new_from_file_format(line)
    todo = Todo.new
    line =~ PriorityContentRegex
    todo.priority = $1.strip
    todo.content = $2.strip
    todo.tags = Todo.find_tags(line.chomp)
    todo
  end

  def self.read_from_disk
    @file_content = File.readlines("/home/edavis/doc/T/Todo/Todo.todo")
  end
end
