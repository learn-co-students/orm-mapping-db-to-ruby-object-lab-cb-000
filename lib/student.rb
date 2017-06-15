class Student
  TABLE_NAME = "students"

   class << self
     def create_table()
       DB[:conn].execute("CREATE TABLE IF NOT EXISTS #{TABLE_NAME} " +
                             "(id INTEGER PRIMARY KEY, name TEXT, grade TEXT)")
     end

     def drop_table()
       DB[:conn].execute("DROP TABLE IF EXISTS #{TABLE_NAME};")
     end

     def create(attributes)
       return Student.new().set_attributes(attributes).save
     end

     def new_from_db(row)
       db_student = self.new(row[1], row[2])
       db_student.id = row[0]
       return db_student
     end

     def all
       return DB[:conn].execute("SELECT * FROM #{TABLE_NAME}").collect { |row|
         self.new_from_db(row)
       }
     end

     def find_by_name(name)
       sql = "SELECT * FROM #{TABLE_NAME} WHERE name = ? LIMIT 1"
       return DB[:conn].execute(sql,name).collect { |row| self.new_from_db(row) }.first
     end

     def count_all_students_in_grade_9()
       return self.all.select {|student| student.grade == "9"}
     end

     def students_below_12th_grade()
       return self.all.select {|student| student.grade.to_i < 12}
     end

     def first_x_students_in_grade_10(nbr_requested)
       return self.all.select {|student| student.grade == "10"}.first(nbr_requested)
     end

     def first_student_in_grade_10()
       return self.first_x_students_in_grade_10(1)[0]
     end

     def all_students_in_grade_x(selected_grade)
       return self.all.select {|student| student.grade == selected_grade.to_s}
     end
   end

   attr_accessor :name, :grade, :id

   def initialize(name=nil, grade=nil)
     self.name = name
     self.grade = grade
   end

   def set_attributes(attributes)
     attributes.each { |key, value| self.send(("#{key}="), value) }
     return self
   end

   def save()
     sql = "INSERT INTO #{TABLE_NAME} (name, grade) VALUES (?, ?)"

     DB[:conn].execute(sql, self.name, self.grade)

     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{TABLE_NAME}")[0][0]

     return self
   end
end
