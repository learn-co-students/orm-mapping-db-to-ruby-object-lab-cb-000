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
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
  def self.all
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
