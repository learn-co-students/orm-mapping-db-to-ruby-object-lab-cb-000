class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]

    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
    SQL

    all_imported = DB[:conn].execute(sql)

    all = []
    all_imported.each do |row|
      student = Student.new
      student.id = row[0]
      student.name = row[1]
      student.grade = row[2]
      all << student
    end

    all
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name).flatten

    student = Student.new
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
    SQL

    rows_array = DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
    SQL

    rows_array = DB[:conn].execute(sql)
  end

  def self.first_X_students_in_grade_10(num_of_rows)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
    SQL

    rows_array = DB[:conn].execute(sql, num_of_rows)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 1
    SQL

    rows_array = DB[:conn].execute(sql).flatten
    student = Student.new
    student.id = rows_array[0]
    student.name = rows_array[1]
    student.grade = rows_array[2]
    student
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
    SQL

    rows_array = DB[:conn].execute(sql, grade)
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
