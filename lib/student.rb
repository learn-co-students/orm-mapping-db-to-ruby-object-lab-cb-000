require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_obj = self.new
    new_obj.id = row[0]
    new_obj.name = row[1]
    new_obj.grade = row[2]
    new_obj
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students;
    SQL

    DB[:conn].execute(sql).map do |data|
      self.new_from_db(data)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = (?);
    SQL

    self.new_from_db(DB[:conn].execute(sql, name).flatten)
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
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 9;
    SQL

    DB[:conn].execute(sql).map do |data|
      self.new_from_db(data)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade <= 11 ;
    SQL

    DB[:conn].execute(sql).map do |data|
      self.new_from_db(data)
    end
  end

  def self.all_students_in_grade_X(limit)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = (?);
    SQL

    DB[:conn].execute(sql, limit).map do |data|
      self.new_from_db(data)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT 1;
    SQL

    DB[:conn].execute(sql).map do |data|
      self.new_from_db(data)
    end.first
  end

  def self.first_X_students_in_grade_10(limit)
    sql = <<-SQL
      SELECT * FROM students
      WHERE grade = 10
      LIMIT (?);
    SQL

    DB[:conn].execute(sql, limit).map do |data|
      self.new_from_db(data)
    end
  end
end
