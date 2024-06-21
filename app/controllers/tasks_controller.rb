class TasksController < ApplicationController

    def index 
        # jwt_key_internal = Rails.application.credentials.jwt_key
        # request_token = request.headers['Authorization']
        # user_id_req = JWT.decode(request_token, jwt_key_internal, true, { :algorithm => 'HS256' })
        # new_user_id = user_id_req.first["user_id"] 

        testVar = ENV['JWT_KEY']

        puts "/////// testVar: #{testVar} ////////////"
        puts "/////// current_user: #{current_user} ////////////" 
        puts "/////// set_current_user_for_tasks: #{set_current_user_for_tasks} ////////////"
        puts "/////// authenticate: #{authenticate} ////////////" 

        if set_current_user_for_tasks 
            puts "if set_current_user_for_tasks"
            render json: set_current_user_for_tasks.tasks 
        else 
            puts "else: task.all"
            render json: Task.all 
        end 
    end 

    def create 
        task = Task.new(task_params) 

        if task.save
            render json: task
        else
            render json: {error: "Task could not be created. Please try again."}
        end

    end 

    def update 
        task = Task.find(params[:id])

        if task.update(task_params)
            render json: task
        end 
    end 

    def show 
        task = Task.find(params[:id])

        if task
            render json: task
        else
            render json: {error: "Task could not be found."}
        end

    end 

    def destroy
        task = Task.find(params[:id])
        
    
        if task
            task.destroy!
            render json: {notice: "Task is destroyed."}
        else
            render json: {error: "Task could not be found."}
        end
    end


    private 

    def task_params
        params.permit(:title, :description, :number, :status, :order, :start_date, :time_to_start, :time_to_finish, :user_id)
    end 

    # def user_id_req()
    #     decoded_token.first["user_id"]
    # end

    def authenticate
        jwt_key_var = ENV['JWT_KEY'] 
        header_token = request.headers["Authorization"]

        if jwt_key_var && header_token
            @auth_user_id = decode_token_process(header_token, jwt_key_var).first["user_id"]
        end
       
    end 

    def decode_token_process(header_token, jwt_key_var)
        begin
            JWT.decode(header_token, jwt_key_var, true, { :algorithm => 'HS256' })
        rescue => exception
            [{error: "Invalid Token"}]
        end 
    end

    def set_current_user_for_tasks
        @user ||= User.find_by(id: authenticate)
    end


end


# stand_up: model 
#   id: number
#   date: string,
#   value_1: {value: string, complete: false: default},
#   value_2: {value: string, complete: false: default},
#   value_3: {value: string, complete: false: default},

# stand_down: model 
#   id: number
#   date: string,
#   value_1: {value: string, complete: false: default},
#   value_2: {value: string, complete: false: default},
#   value_3: {value: string, complete: false: default},

    