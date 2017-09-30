require 'pry'

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
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT *
    FROM students
    SQL

    DB[:conn].execute(sql).map do | row |
      new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name).first

    new_from_db(row)
  end

  def self.all_students_in_grade_X(grade)
    all.select do |student|
      student.grade.to_i == grade.to_i
    end
  end

  def self.count_all_students_in_grade_9
    all_students_in_grade_X("9")
  end

  def self.students_below_12th_grade
    all.delete_if do |student|
      student.grade == "12"
    end
  end

  def self.first_student_in_grade_10
    all_students_in_grade_X(10).first
  end

  def self.first_X_students_in_grade_10(count)
    all_students_in_grade_X(10)[0..count-1]
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
