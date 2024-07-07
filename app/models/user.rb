class User < ApplicationRecord
    has_secure_password 

    has_many :tasks
    has_many :projects
    has_many :standup

    validates :username, presence: {message: "Username field is empty."}
    validates :password, presence: {message: "Password field is empty."}
    validates :email, presence: {message: "Email field is empty."}
end
