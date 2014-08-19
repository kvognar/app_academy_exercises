class QuestionFollower
  attr_accessor :id, :question_id, :user_id

  def self.all
    results = QuestionsDatabase.instance.execute('SELECT * FROM question_followers')
    results.map { |result| QuestionFollower.new(result) }
  end
  
  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    
    SELECT
    *
    FROM
    question_followers
    WHERE
    id = ?
    SQL
    
    QuestionFollower.new(result.first)
  end
  
  def self.followers_for_question_id(question_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    
    SELECT
      users.*
    FROM
      question_followers 
    JOIN 
      users 
    ON 
      users.id = user_id
    WHERE
      question_id = ?
    SQL
    
    results.map { |result| User.new(result) }
  end
  
  def self.followed_questions_for_user_id(user_id)
    results = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    
    SELECT
      questions.*
    FROM
      question_followers 
    JOIN 
      questions 
    ON 
      questions.id = question_id
    WHERE
      user_id = ?
    SQL
    
    results.map { |result| Question.new(result) }
  end
  
  def initialize(options = {})
    @id, @question_id, @user_id =
    options.values_at('id', 'question_id', 'user_id')
  end
end