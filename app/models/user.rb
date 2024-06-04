class User < ApplicationRecord
    has_secure_password 

    has_many :tasks
    has_many :projects

    # validates :username, presence: {message: "First name field is empty."}
    # validates :email, presence: {message: "Last name field is empty."}
end
