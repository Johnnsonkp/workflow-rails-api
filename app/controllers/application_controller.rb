class ApplicationController < ActionController::API
    # before_action :set_current_user
    before_action :current_user

    def jwt_key
        Rails.application.credentials.jwt_key
    end

    def issue_token(user)
        JWT.encode({user_id: user.id}, jwt_key, "HS256")
    end

    def decoded_token
        begin
            JWT.decode(token, jwt_key, true, { :algorithm => 'HS256' })
        rescue => exception
            [{error: "Invalid Token"}]
        end    
    end

    def token
        request.headers["Authorization"]
    end

    def user_id
        decoded_token.first["user_id"]
    end

    def current_user
        # return unless session[:user_id]
        # @current_user ||= User.find_by_id(session[:user_id])
        @user ||= User.find_by(id: user_id)
        # @current_user
    end


    def user_session
        @user
    end

    def logged_in?
        !!current_user
    end

    # def set_current_user
    #     # @current_user ||= User.find_by(id: session[:user_id])
    #     # @current_user ||= User.find_by(id: @user.id)

    #     @current_user ||= User.find_by(id: user_id)
    #     # render json: {message: @current_user}
    # end
    
    # private

    # def current_user
    #     return unless session[:user_id]
    #     @current_user ||= User.find_by_id(session[:user_id])
    # end

    # before_action :current_user
    # before_action :set_current_user

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
    #     # @user = User.find_by(id: user_id)
    # end

    # def logged_in?
    #     !!current_user
    # end


# //////////////////////////////////////////////////////////////////////

    # def logged_in_user
    #     if decoded_token
    #     #   user_id = decoded_token[0]['user_id']
    #       @user = User.find_by(id: user_id)
    #     end
    # end
    
    # def logged_in?
    #     !!logged_in_user
    # end

    # def authorized
    #     render json: {message: 'You need to log in'}, status: :unauthorized unless logged_in?
    # end

    # def set_current_user
    #     if session[:user_id]
    #       Current.user = User.find_by(id: session[:user_id])
    #     #   @current_user_session = Current.user
    #     end 
    # end

# ///////////////////////////////////////////////////////////////////////


end
