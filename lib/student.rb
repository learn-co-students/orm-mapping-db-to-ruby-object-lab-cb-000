class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    self.new.tap do |student|
			student.id = row[0]
			student.name = row[1]
			student.grade = row[2]
		end
  end

  def self.all
		DB[:conn].execute("SELECT * FROM students").collect{|row| self.new_from_db(row)}
  end

  def self.find_by_name(name)
		array = DB[:conn].execute("SELECT * FROM students WHERE name = ? LIMIT 1", name)[0]
		self.new_from_db(array) if array
  end

	def self.all_students_in_grade_x(grade)
		DB[:conn].execute("SELECT * FROM students WHERE grade=?",grade).collect{|row| self.new_from_db(row)}
	end

	def self.count_all_students_in_grade_9()
		self.all_students_in_grade_x(9)
	end

	def self.students_below_12th_grade()
		DB[:conn].execute("SELECT * FROM students WHERE grade<12").collect{|row| self.new_from_db(row)}
	end

	def self.first_x_students_in_grade_10(amt)
		DB[:conn].execute("SELECT * FROM students WHERE grade=10 LIMIT ?", amt).collect{|row| self.new_from_db(row)}
	end

	def self.first_student_in_grade_10()
		self.first_x_students_in_grade_10(1)[0]
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
end
