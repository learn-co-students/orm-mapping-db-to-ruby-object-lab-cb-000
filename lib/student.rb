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
    # find the student in the database given a name
    # return a new instance of the Student class
  def self.find_by_name(name)
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
