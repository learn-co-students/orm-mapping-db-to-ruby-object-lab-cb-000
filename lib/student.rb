class Student
  attr_accessor :id, :name, :grade

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT COUNT(grade) FROM students WHERE grade = 9
    SQL

    count = DB[:conn].execute(sql)
    count[0]
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students WHERE grade < 12
    SQL

    rows = DB[:conn].execute(sql)
    rows.collect {|row| self.new_from_db(row)}
  end

  def self.first_x_students_in_grade_10(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL

    rows = DB[:conn].execute(sql, x)
    rows.collect {|row| self.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    students = self.first_x_students_in_grade_10(1)
    students[0]
  end

  def self.all_students_in_grade_x(x)
    sql = <<-SQL
      SELECT * FROM students WHERE grade = ?
    SQL

    rows = DB[:conn].execute(sql, x)
    rows.collect {|row| self.new_from_db(row)}
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
    SQL

    rows = DB[:conn].execute(sql)
    rows.collect {|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL

    rows = DB[:conn].execute(sql, name)
    self.new_from_db(rows[0])
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
