class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    return student


    # create a new Student object given a row from the database
#    student = Student.new

  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT * FROM students WHERE name = ?
    SQL

    data = DB[:conn].execute(sql, name)
    Student.new_from_db(data.flatten)
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

  def self.count_all_students_in_grade_9
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 9
    SQL
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
    SELECT * FROM students where grade < 12
    SQL
    DB[:conn].execute(sql)
  end

  def self.all
    blah = DB[:conn].execute("SELECT * FROM students")
    blah.map {|stud| Student.new_from_db(stud)}
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT ?
    SQL

    DB[:conn].execute(sql,x)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students WHERE grade = 10 LIMIT 1
    SQL
    student = Student.new_from_db(DB[:conn].execute(sql).flatten)
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
    SELECT * FROM students where grade = ?
    SQL
    DB[:conn].execute(sql,x)
  end
end
