class WorksController < ApplicationController
    
    
    def edit
        
        
        
    end
    
    
    
    def show
        
        if params[:month]
          @this_month = params[:month].to_date
        else
          @this_month = Date.today 
        end   
            
        @current_user = User.find(current_user.id)
        
        @admin_user = User.find_by(admin: true)
    
        
    end
    
    
    
    
    
    
end
