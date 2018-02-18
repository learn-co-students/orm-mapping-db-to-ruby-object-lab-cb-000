class Student
  attr_accessor :id, :name, :grade

  # create a new Student object given a row from the database
  # This is a class method that accepts a row from the database as an argument
  # It then creates a new student object based on the information in the row
  # Remember, the database doesn't store Ruby objects, so we have to manually convert it
  def self.new_from_db(row)
    new_student = Student.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  # returns all student instances from the db
    # This is a class method that returns everything in the database
    # First, run the SQL to return everything (*) from a table
    # Then, use the .new_from_db method to create a student instance for each row that comes back from the database
  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # returns an instance of student that matches the name from the DB
    # This is a class method that accepts a name of a student
    # First, run a SQL query to get the result from the database where the student's name matches the name passed into the argument
    # Next, take the result and create a new student instance using the .new_from_db method
  def self.find_by_name(name)
    # 1. use a question mark where we want the name parameter to be passed in
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row| # 2. then include name as the second argument to the execute method
      self.new_from_db(row)
    end.first # The return value of the .map method is an array, so use the .first method to grab the first element from the returned array
  end

  # returns an array of all students in grades 9
    # This is a class method that does not need an argument
  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # returns an array of all students in grades 11 or below
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade <= 11
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  # returns an array of the first X students in grade 10
  def self.first_X_students_in_grade_10
  end

  # returns the first student in grade 10
  def first_student_in_grade_10
  end

  # returns an array of all students in a given grade X
  def self.all_students_in_grade_X
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
