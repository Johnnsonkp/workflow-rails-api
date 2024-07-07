class TasksController < ApplicationController
    before_action :get_user_id_method

    def index 
        @user = User.find_by(id: get_user_id_method)

        if @user 
            render json: @user.tasks 
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

    def authenticate(jwt_key_var, header_token)
        # jwt_key_var = ENV['JWT_KEY'] 
        # header_token = request.headers["Authorization"]

        if jwt_key_var && header_token
            # @auth_user_id = decode_token_process(header_token, jwt_key_var).first["user_id"]

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


    