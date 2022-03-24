require "sqlite3"
require "singleton"

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end
end
  
class User

    attr_accessor :fname, :lname
    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * FROM users WHERE id = ?
        SQL
        data = data.map {|datum| self.new(datum)}.first
    end

    def self.find_by_name(fname,lname)
        data = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            SELECT * FROM users WHERE fname = ? AND lname = ?
        SQL
        data = data.map {|datum| self.new(datum)}.first
    end
    
    def initialize(options)
        @id = options["id"]
        @fname = options["fname"]
        @lname = options["lname"]
    end

    def authored_questions
        Question.find_by_author_id(@id)
    end

    def authored_replies
        Reply.find_by_user_id(@id)
    end

    def followed_questions 
        QuestionFollow.followed_questions_for_user_id(@id)
    end
    
    def liked_questions
        QuestionLike.liked_questions_for_user_id(@id)
    end

    def average_karma
        data = QuestionsDatabase.instance.execute(<<-SQL,@id)
        SELECT
            id, fname, lname, average
        FROM
            users
        LEFT JOIN
        (SELECT
            user_id, CAST(SUM(likes) AS FLOAT)/COUNT(questions.title) AS average
        FROM
            questions
        LEFT JOIN
            (SELECT question_id,COUNT(liker_id) AS likes
            FROM questions 
            LEFT JOIN question_likes ON questions.id = question_id
            WHERE question_id IS NOT NULL
            GROUP BY question_id)
        ON
            questions.id = question_id
        GROUP BY
            user_id)
        ON
            users.id = user_id
        WHERE
            id = ?
        SQL
        data.first['average']
    end
# user = Users.new(options) options = {fname = Jerry, lname = Park}
# user.save
    def save
        if @id.nil?
            data = QuestionsDatabase.instance.execute(<<-SQL,self.fname,self.lname)
                INSERT INTO
                    users (fname,lname)
                VALUES
                    (?,?)
            SQL
            @id = QuestionsDatabase.instance.last_insert_row_id
        else
            data = QuestionsDatabase.instance.execute(<<-SQL,self.fname,self.lname,@id)
                UPDATE
                    users
                SET
                    fname = ?,lname = ?
                WHERE
                    id = ?
            SQL
       end
    end
end

class Question 
    
    attr_accessor :title, :body, :user_id

    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * FROM questions WHERE id = ?
        SQL
        data = data.map {|datum| self.new(datum)}.first
    end

    def self.find_by_author_id(author_id)
        User.find_by_id(author_id)
    end

    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
    end

    def initialize(options)
        @id = options["id"]
        @title = options["title"]
        @body = options["body"]
        @user_id = options["user_id"]
    end

    def author
        User.find_by_id(@id)
    end

    def replies
        Reply.find_by_question_id(@id)
    end

    def followers 
        QuestionFollow.followers_for_question_id(@id)
    end

    def likers
        QuestionLike.likers_for_question_id(@id)
    end

    def num_likes
        QuestionLike.num_likes_for_question_id(@id)
    end
end

class Reply
    attr_accessor :parent_reply, :body, :replier_id, :question_id
    
    def self.find_by_id(id)
        data = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT * FROM replies WHERE id = ?
        SQL
        data = data.map {|datum| self.new(datum)}.first
    end

    def self.find_by_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT * FROM replies WHERE replier_id = ?
        SQL
        data = data.map {|datum| self.new(datum)}
    end
    
    def self.find_by_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT * FROM replies WHERE question_id = ?
        SQL
        data = data.map {|datum| self.new(datum)}
    end

    def initialize(options)
        @id = options['id']
        @replier_id = options['replier_id']
        @question_id = options['question_id']
        @parent_reply = options['parent_reply']
        @body = options['body']
    end

    def author
        User.find_by_id(replier_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        Reply.find_by_id(parent_reply)
    end

    def child_replies
        data = QuestionsDatabase.instance.execute(<<-SQL, @id)
            SELECT * FROM replies WHERE parent_reply = ?
        SQL
        data = data.map {|datum| Reply.new(datum)}
    end
end

class QuestionFollow

    def self.followers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT users.id, fname, lname FROM question_follows
            JOIN users ON question_follows.follower_id = users.id
            WHERE question_id = ?
        SQL
        data = data.map {|datum| User.new(datum)}
    end 

    def self.followed_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT questions.id, title, body, questions.user_id FROM question_follows
            JOIN questions ON question_follows.question_id = questions.id
            WHERE follower_id = ?
        SQL
        data = data.map {|datum| Question.new(datum)}
    end

    def self.most_followed_questions(n)
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT *
        FROM questions
        WHERE
            id IN (SELECT question_id
            FROM question_follows
            GROUP BY question_id
            ORDER BY COUNT(follower_id) DESC
            LIMIT ?)
        SQL
        data = data.map {|datum| Question.new(datum)}
    end

end

class QuestionLike

    def self.likers_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT users.id, users.fname, users.lname FROM question_likes
            JOIN users ON question_likes.liker_id = users.id
            WHERE question_id = ?
        SQL
        data = data.map {|datum| User.new(datum)}
    end

    def self.num_likes_for_question_id(question_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT COUNT(liker_id) AS Num_of_Likes FROM question_likes
            WHERE question_id = ?
        SQL
        data[0]['Num_of_Likes']
    end

    def self.liked_questions_for_user_id(user_id)
        data = QuestionsDatabase.instance.execute(<<-SQL, user_id)
            SELECT questions.id, questions.title, questions.body, questions.user_id FROM question_likes
            JOIN questions ON question_likes.question_id = questions.id
            WHERE liker_id = ?
        SQL
        data = data.map {|datum| Question.new(datum)}
    end

    def self.most_liked_questions(n)
        data = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT *
        FROM questions
        WHERE
            id IN (SELECT question_id
            FROM question_likes
            GROUP BY question_id
            ORDER BY COUNT(liker_id) DESC
            LIMIT ?)
        SQL
        data = data.map {|datum| Question.new(datum)}
    end
end