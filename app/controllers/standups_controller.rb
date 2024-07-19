class StandupsController < ApplicationController
    before_action :get_user_id_method

    def new
        @stand_up = Standup.new
        3.times { @stand_up.standup_tasks.build }
    end

    def all 
        @stand_up = Standup.all

        if @stand_up 
            puts "All stand up: #{@stand_up}"
            @std_arr = []

            @stand_up.each do |stand_up_params|
                @std_arr.push({stand_up: stand_up_params, stand_up_tasks: stand_up_params.standup_tasks})
            end 

            puts "std_arr: #{@std_arr}"
            # render json: {date: @stand_up.date, standup_tasks: @stand_up.standup_tasks}
        end 
    end

    def show
    end

    def index 
        @stand_up = Standup.where(user_id: get_user_id_method).last

        if @stand_up 
            # render json: {date: @stand_up.date, standup_tasks: @stand_up.standup_tasks}
            render json: {stand_up: @stand_up, standup_tasks: @stand_up.standup_tasks}
        end 
    end 

    def create 
        @stand_up = Standup.new(date: params[:date], user_id: params[:user_id])
        @req_stand_up = params[:standup_tasks]
    
        if @stand_up.save
            @req_stand_up.each do |stand_up_params|
                @stand_up.standup_tasks.create(title: stand_up_params[:title], complete: stand_up_params[:complete])
            end
            render json: {date: @stand_up.date, standup_tasks: @stand_up.standup_tasks}
        else
            render json: {error: "Stand up could not be created. Please try again."}
        end
    end 

    def update 
        @stand_up_task = StandupTask.find_by(id: params[:id])
        @stand_up_task.update(title: params[:title], complete: params[:complete], standup_id: params[:standup_id])

        if @stand_up_task
            puts "@stand_up_task: #{@stand_up_task}"
            render json: @stand_up_task
        end 
    end 

    private 

    # def standup_task_1
    #     params.permit({:id_1, :title, :complete}, {:id_2, :title, :complete}, {:id_3, :title, :complete})
    # end

    def standup_task_2
        params.permit(:id_2, :title, :complete)
    end

    def standup_task_3
        params.permit(:id_3, :title, :complete)
    end

    # def standup_task_3
    #     params.permit(standup_tasks_attributes: [:id_3, :title, :complete])
    # end

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
