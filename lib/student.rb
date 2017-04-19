class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.map_from_db(arrays)
    arrays.map{|row|self.new_from_db(row)}
  end

  def self.all
    s = DB[:conn].execute("SELECT * FROM  students")[0]
    self.new_from_db(s)
  end

  def self.find_by_name(name)
    s = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1",name)[0]
    self.new_from_db(s)
  end




  def self.count_all_students_in_grade_9
    self.map_from_db( DB[:conn].execute("SELECT * FROM students WHERE grade = 9") )
  end

  def self.students_below_12th_grade
    self.map_from_db( DB[:conn].execute("SELECT * FROM students WHERE grade < 12") )
  end

  def self.first_x_students_in_grade_10(x)
    self.map_from_db( DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT ?",x) )
  end

  def self.first_student_in_grade_10
    self.new_from_db( DB[:conn].execute("SELECT * FROM students WHERE grade = 10 LIMIT 1")[0] )
  end

  def self.all_students_in_grade_x(x)
    self.map_from_db( DB[:conn].execute("SELECT * FROM students WHERE grade = ?",x) )
  end

  def self.all
    self.map_from_db( DB[:conn].execute("SELECT * FROM students") )
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
