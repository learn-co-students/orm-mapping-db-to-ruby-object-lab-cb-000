class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    sql = <<-SQL
      SELECT *
      FROM students
      SQL
      DB[:conn].execute(sql).map do |row|
        self.new_from_db row
      end
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

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
      SQL
    student_info = DB[:conn].execute(sql, name)[0]
    self.new_from_db student_info
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 9
      SQL
    students_in_grade_9 = DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade < 12
      SQL
    students_in_grade_12 = DB[:conn].execute(sql)
  end

  def self.first_x_students_in_grade_10 x
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT ?
      SQL
    students_in_grade_10 = DB[:conn].execute(sql, x)
  end

  def self.first_student_in_grade_10
    student_info = self.first_x_students_in_grade_10(1).first
    student = self.new_from_db student_info
  end

  def self.all_students_in_grade_x x
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = ?
      SQL
    students_in_grade_x = DB[:conn].execute(sql, x)
  end
end
