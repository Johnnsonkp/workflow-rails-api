class TasksController < ApplicationController

    def index 
        request_token = request.headers['Authorization']
        tasks = Task.where(user_id: user_id)
        

        if tasks
            puts "///// request token: #{request_token} ////////"
            render json: tasks
        else
            render json: {error: "Task could not be found."}
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

    # def set_current_user
    #     # params.permit(:request)
    #     @current_user ||= User.find_by(id: user_id)
    # end 

    # def authorized_user 
    #     params.permit(:Authorization)
    # end


    # def jwt_key
    #     Rails.application.credentials.jwt_key
    # end

    # def issue_token(user)
    #     JWT.encode({user_id: user.id}, jwt_key, "HS256")
    # end

    # def decoded_token
    #     begin
    #         JWT.decode(token, jwt_key, true, { :algorithm => 'HS256' })
    #     rescue => exception
    #         [{error: "Invalid Token"}]
    #     end    
    # end

    # def token
    #     request.headers["Authorization"]
    # end

    # def user_id
    #     decoded_token.first["user_id"]
    # end

    # def current_user
    #     @user ||= User.find_by(id: user_id)
    # end

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

    