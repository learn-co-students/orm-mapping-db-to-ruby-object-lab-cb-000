class Student
  attr_accessor :id, :name, :grade

  # Create a new Student object given a row from the database
  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  # Retrieve all the rows from the "Students" database
  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map { |row| self.new_from_db(row)}
  end

  # find the student in the database given a name
  # return a new instance of the Student class
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL

    DB[:conn].execute(sql, name).map { |row| self.new_from_db(row)}[0]
  end

  # Returns all students in grade 9
  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map { |row| self.new_from_db(row)}
  end

  # Returns all students in grades 11 or below
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade < 12
    SQL

    DB[:conn].execute(sql).map { |row| self.new_from_db(row)}
  end

  # Returns the first X students in grades 10
  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    DB[:conn].execute(sql, x).map { |row| self.new_from_db(row)}
  end

  # Returns the first student in grade 10
  def self.first_student_in_grade_10
    self.first_x_students_in_grade_10(1).first
  end

  # Returns an array of all students in a given grade X
  def self.all_students_in_grade_x(x)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ?
    SQL

    DB[:conn].execute(sql, x).map { |row| self.new_from_db(row)}
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

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
