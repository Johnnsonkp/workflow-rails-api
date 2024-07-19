# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Users
if User.length < 1 
    User.create(username: "Test1", email: "test1@gmail.com", password: "1234")
end 


if Habit.length < 1
    Habit.create(
        title: "Bible study",
        description: "Daily bible study ",
        current_streak: 2,
        entries: [
            Entry.new(date: '2024-07-14', complete: true),
            Entry.new(date: '2024-07-15', complete: true),
        ]
    )

    Habit.create(
        title: "Daily read",
        description: "Read at least 10 pages per day",
        current_streak: 0,
        entries: [
            Entry.new(date: '2024-07-14', complete: true),
            Entry.new(date: '2024-07-15', complete: false),
        ]
    )
end
  