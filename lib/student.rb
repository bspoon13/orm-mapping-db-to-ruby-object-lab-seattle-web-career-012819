require 'pry'

class Student
  attr_accessor :id, :name, :grade
  @@all = []
# create a new Student object given a row from the database
  def initialize(id = nil, name = nil, grade = nil)
    #binding.pry
    @name = name
    @grade = grade
    @id = id
    #@@all << self
  end



  def self.new_from_db(row)
    Student.new(row[0], row[1], row[2])
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL
    rows = DB[:conn].execute(sql)
    @@all = rows.map { |student| Student.new_from_db(student)}
  end

  # find the student in the database given a name
  # return a new instance of the Student class
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.name = ?
    SQL
    #binding.pry
    Student.new_from_db(DB[:conn].execute(sql, name)[0])
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = ?
    SQL

    DB[:conn].execute(sql, "9")
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade < ?
    SQL
    rows = DB[:conn].execute(sql, 12)
    #binding.pry
    rows.map do |student|
      #binding.pry
      Student.new_from_db(student)
    end

  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = ?
      LIMIT ?
    SQL
    rows = DB[:conn].execute(sql, 10, x)
    #binding.pry
    rows.map do |student|
      #binding.pry
      Student.new_from_db(student)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = ?
      LIMIT ?
    SQL
    rows = DB[:conn].execute(sql, 10, 1)
    #binding.pry
    Student.new_from_db(rows[0])
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = ?
    SQL
    rows = DB[:conn].execute(sql, x)
    #binding.pry
    rows.map do |student|
      #binding.pry
      Student.new_from_db(student)
    end
  end
end
