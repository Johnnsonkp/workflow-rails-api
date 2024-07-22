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
                unique_entries = habit.entries.uniq { |entry| entry.date }
                sorted_entries = unique_entries.sort { |a, b| a[:date].slice(0,2).to_i <=> b[:date].slice(0,2).to_i  }


                sorted_entries.entries.each do |entry|
                    puts "\\\\\\ AFTER #{entry.date} ///////////////"
                    if entry.date && entry.date.slice(0,2).to_i <= formatted_date.slice(0,2).to_i
                        if entry.date && entry.complete? 
                            num += 1 
                        else 
                            num = 0 
                        end 
                    end
                end 
                
                habit.current_streak = num
                habit_arr.push({habit: habit, entries: sorted_entries})
            end 
            render json: habit_arr
        end 
    end 

    def create 
        @habit = Habit.new(title: params[:title], description: params[:description], current_streak: 0, user_id: params[:user_id])
    
        if @habit.save
            render json: @habit
        else
            render json: {error: "Habit could not be created. Please try again."}
        end
    end 

    def update 
        @habit = Habit.find(params[:id])
        request_params = {date: params[:date], complete: params[:complete]}
        habit_arr = []

        if @habit && @habit.entries.size > 0
            entry_to_update = @habit.entries.find_by(date: params[:date])
            updated_entry = @habit.entries.find_by(date: params[:date]).update(complete: params[:complete])

            if updated_entry
                render json: {habit: @habit, entries: @habit.entries }
            end

        else 
            entry_presence = @habit.entries.find_by(date: params[:date])
            if !entry_presence 
                puts "\\\\\\\\\\\\\\ Create !entry_presence & create_new_entry //////////////"
                @habit.entries.create(request_params)
                render json: {habit: @habit, entries: @habit.entries }
            end 
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

    def remove_dup_entries_update_data(habits)
        sorted_entries = []
        habits.each do |habit| 
            habit.entries.reverse
            unique_entries = habit.entries.uniq { |entry| entry.date }
            sorted_entries.push(unique_entries.entries.sort { |a, b| a[:date].slice(0,2).to_i <=> b[:date].slice(0,2).to_i  })
        end 

        return sorted_entries
    end 

    def habitObjConstruct(habit) 
        habit_arr = []
        habit.each do |h| 
            habit_arr.push({habit: h, entries: h.entries})
            puts "///////// #{habit_arr} ///////////"
        end 
        render json: habit_arr
    end 

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
