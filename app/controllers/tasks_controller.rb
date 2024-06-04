class TasksController < ApplicationController
    def index 
        task = Task.all

        if task
           return render json: task.order(:status) || task.order(:order)
        else
            render json: {error: "Task could not be found."}
        end

    end 

    def create 
        task = Task.new(task_params)
        # task = current_user.task.new(task_params)

        if task.save
            render json: task
        else
            # render json: {error: "Task could not be created. Please try again."}
            render json: {error: task_params}
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
        params.permit(:title, :description, :status, :order, :start_date, :time_to_start, :time_to_finish, :user_id)
    end 

end
