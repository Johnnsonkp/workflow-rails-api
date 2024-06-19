class ProjectsController < ApplicationController
    before_action :user_id
    before_action :set_current_user

    def index 
        @projects = Project.all 

        if @projects 
            render json: @projects
        else 
            render json: {error: "No projects found"}
        end 
    end 

    def create 
        project = set_current_user.Project.new(project_params)

        if project 
            render json: project 
        else 
            render json: {error: "Project could not be created"}
        end 
    end 

    def update 
    end 

    private 

    def project_params 
        params.permit(:title, :description, :start_date, :finish_date)
    end 
end
