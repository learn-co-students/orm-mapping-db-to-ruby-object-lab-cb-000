class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    stud = self.new
    stud.id = row[0]
    stud.name = row[1]
    stud.grade = row[2]
    stud
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ? ;
    SQL
    row = DB[:conn].execute(sql, name)
    self.new_from_db(row[0])
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    table = DB[:conn].execute(sql)
    table.map do |row|
      stud = self.new_from_db(row)
      stud
    end
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9 ;
    SQL
    table = DB[:conn].execute(sql)
    table
  end
  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade <= 11 ;
    SQL
    table = DB[:conn].execute(sql)
    table.map do |row|
      stud = self.new_from_db(row)
      stud
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?);
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end
  def self.first_X_students_in_grade_10(number)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ? ;
    SQL
    table = DB[:conn].execute(sql, number)
    table
  end
  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT ? ;
    SQL
    table = DB[:conn].execute(sql, 1)
    stud = self.new_from_db(table[0])
    stud
  end

  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = ? ;
    SQL
    table = DB[:conn].execute(sql, grade)
    table.map do |row|
      stud = self.new_from_db(row)
      stud
    end
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
