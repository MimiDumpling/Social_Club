class User < ApplicationRecord
	has_many :payments
	
    validates :email, presence: true,
                    length: { maximum: 255 },
                    uniqueness: { case_sensitive: false },
                    # https://www.railstutorial.org/book/modeling_users
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
    validates :password, presence: true,
              length: { minimum: 8, maximum: 30 }

    has_secure_password
end
