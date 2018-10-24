require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = self.new
    saved_row = row
    student.id = saved_row[0]
    student.name =  saved_row[1]
    student.grade = saved_row[2]
    student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    student_array =[]
    sql="SELECT * FROM students"
    student_rows= DB[:conn].execute(sql)
    student_rows.each do |item|
    student_array << self.new_from_db(item)
    end
    student_array
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    stored_name= name
    sql="SELECT * FROM students WHERE name = '#{stored_name}';"
    student_info = DB[:conn].execute(sql).flatten
    self.new_from_db(student_info)
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

def self.all_students_in_grade_9
  sql="SELECT * FROM students WHERE grade = 9;"

  student_info = DB[:conn].execute(sql)

  student_info
end


def self.students_below_12th_grade
  array = []
  sql="SELECT * FROM students WHERE grade < 12;"
  student_info = DB[:conn].execute(sql)
  student_info.each do |item|
  array << self.new_from_db(item)
  end
  array
end


def self.first_X_students_in_grade_10(number)
  array = []
  sql="SELECT * FROM students WHERE grade = 10;"
  student_info = DB[:conn].execute(sql)
  student_info[0..number-1].each do |item|
  array << self.new_from_db(item)
  end
array

end

def self.first_student_in_grade_10
    self.first_X_students_in_grade_10(1)[0]
end

def self.all_students_in_grade_X(number)
  stored_number = number
  sql="SELECT * FROM students WHERE grade = '#{stored_number}';"
  student_info = DB[:conn].execute(sql)
  student_info
end




end
