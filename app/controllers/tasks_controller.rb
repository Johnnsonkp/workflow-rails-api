class TasksController < ApplicationController
    before_action :set_current_user
    before_action :user_id
    before_action :token


    def index 
        tasks = @current_user.tasks
        # tasks = Task.all

        if tasks
            # render json: tasks
            # render json: Rails.env
            puts "///////////////// Rails environment: #{Rails.env} /////////////////"
            puts "///////////////// current_user.id: #{@current_user.id} /////////////////"
            puts "///////////////// user: #{@user} /////////////////"
            puts "///////////////// user_id: #{user_id} /////////////////"
            puts "///////////////// token: #{token} /////////////////"
        else
            render json: {error: "Task could not be found."}
        end

    end 

    def create 
        # @task = current_user.tasks.build(task_params)
        # task = set_current_user.Task.new(task_params) 
        task = @current_user.Task.new(task_params) 

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

    def set_current_user
        # params.permit(:request)
        @current_user ||= User.find_by(id: user_id)
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

    