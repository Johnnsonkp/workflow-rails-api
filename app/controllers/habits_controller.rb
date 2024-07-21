class HabitsController < ApplicationController
    before_action :get_user_id_method

    def new
    end

    def all 
    end

    def show
    end

    def index 
        @habits = Habit.where(user_id: get_user_id_method)

        if @habits 
            habit_arr = []
            @habits.each do |habit| 
                current_time = Date.today
                formatted_date = current_time.strftime("%d/%m/%y")
                num = 0
                
                habit.entries.reverse
                habit.entries.each do |entry|
                    # if formatted_date == entry.date && entry.complete? 
                    if entry.date && entry.complete? 
                        num += 1 
                    else 
                        num = 0 
                    end 
                end 
                
                habit.current_streak = num
                habit_arr.push({habit: habit, entries: habit.entries})
            end 
            render json: habit_arr
        end 
    end 

    def create 
        @habit = Habit.new(title: params[:title], description: params[:description], current_streak: 0, user_id: params[:user_id])
    
        if @habit.save
            render json: @habit
        else
            render json: {error: "Stand up could not be created. Please try again."}
        end
    end 

    def update 
        @habit = Habit.find(params[:id])
        # @habit.entries.create(date: params[:date], complete: params[:complete])
        habit_arr = []
        request_params = {date: params[:date], complete: params[:complete]}

        if @habit.entries.size > 0
            puts "Entry size #{@habit.entries.size}"

            @habit.entries.each do |entry|
              if entry.date == params[:date]

                entry.update(request_params)
                if entry.update(request_params)
                    puts "Entry succesfully updated //////////////////////////"
                    break
                end 

              else
                habit_arr.push(request_params)
                @habit.entries.create(habit_arr.last)
                puts "Push /////////////////// habit_arr entry created: #{habit_arr}"
                break
              end
            end

        else 
            @habit.entries.create(request_params)
        end

        # render json: {habit: @habit, entries: @habit.entries }
        if @habits 
            habit_arr = []
            @habits.each do |habit| 
                habit_arr.push({habit: habit, entries: habit.entries})
            end 
            render json: habit_arr
        end 
    end 

    def destroy
        habit = Habit.find(params[:id])
        
    
        if habit
            habit.destroy!
            render json: {notice: "Habit is destroyed."}
        else
            render json: {error: "Habit could not be found."}
        end
    end

    private 

    def standup_params
        params.require(:stand_up).permit(:date, standup_tasks_attributes: [:title, :complete])
    end
    

    def authenticate(jwt_key_var, header_token)
        if jwt_key_var && header_token
            begin
                JWT.decode(header_token, jwt_key_var, true, { :algorithm => 'HS256' })
            rescue => exception
                [{error: "Invalid Token"}]
            end 
        end
    end 


    def get_user_id_method
        jwt_key_var = ENV['JWT_KEY'] ||  Rails.application.credentials.jwt_key
        header_token = request.headers["Authorization"]

        decoded_token = authenticate(jwt_key_var, header_token)
        get_user_id = decoded_token.first['user_id']
    end
end
