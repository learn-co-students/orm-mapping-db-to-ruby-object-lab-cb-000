class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = new
    student.id, student.name, student.grade = row

    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    result = DB[:conn].execute(sql)

    result.map { |row| new_from_db row }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class

    sql = "SELECT * FROM students WHERE name = ?"
    result = DB[:conn].execute(sql, name)

    new_from_db result.first
  end

  def self.count_all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = 9"
    result = DB[:conn].execute(sql)

    result.map { |row| new_from_db row }
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < 12"
    result = DB[:conn].execute(sql)

    result.map { |row| new_from_db row }
  end

  def self.first_x_students_in_grade_10(limit)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    result = DB[:conn].execute(sql, limit)

    result.map { |row| new_from_db row }
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10"
    result = DB[:conn].execute(sql)

    new_from_db result.first
  end

  def self.all_students_in_grade_x(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    result = DB[:conn].execute(sql, grade)

    result.map { |row| new_from_db row }
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
