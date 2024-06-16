class TasksController < ApplicationController

    def index 
        # tasks = Task.all
        # tasks = Task.where(user_id: @user.id) || Task.all
        # tasks = Task.where(user_id: @user.id)
        tasks = Task.where(user_id: current_user.id)
        # render json: User.all
        # User.find_by(id: user_id)
        # @tasks = Task.where(user_id: @user.id) || Task.all

        if tasks
           return render json: tasks.order(:status) || tasks.order(:order)
        else
            render json: {error: "Task could not be found."}
        end

        # @tasks = Task.where(user_id: @user.id) || Task.all

        # if @tasks
        #    return render json: @tasks.order(:status) || @tasks.order(:order)
        # else
        #     render json: {error: "Task could not be found."}
        # end

    end 

    def create 
        @task = Task.new(task_params)
        # task = current_user.task.new(task_params)

        if @task.save
            render json: @task
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
        params.permit(:title, :description, :number, :status, :order, :start_date, :time_to_start, :time_to_finish, :user_id)
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

    