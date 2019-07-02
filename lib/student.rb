class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def save
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten[0]
  end

  class << self
    def create_table
      sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
      );
      SQL
      DB[:conn].execute(sql)
    end

    def drop_table
      sql = <<-SQL
      DROP TABLE IF EXISTS students;
      SQL
      DB[:conn].execute(sql)
    end

    def create(name:, grade:)
      student = Student.new(name, grade)
      student.save
      student
    end
  end
end
