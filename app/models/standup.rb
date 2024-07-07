class Standup < ApplicationRecord
    has_many :standup_tasks, dependent: :destroy 
    belongs_to :user

    accepts_nested_attributes_for :standup_tasks
end

