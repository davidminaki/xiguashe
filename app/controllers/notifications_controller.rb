class NotificationsController < ApplicationController
  
  before_filter :logined?

  def index

  	@user = User.find(params[:user_id])
  	
  	@notifications = @user.notices(params[:page],Notification.per_page)

  end


  def read
  	@notification = Notification.find(params[:id])
  	@notification.update_attributes({:is_read => true})

  	if params[:type] == '0'
  		redirect_to @notification.notificationable.commentable
  	elsif params[:type] == '1'
  		redirect_to user_notifications_path(current_user)
  	end
  end

  def destroy
  	@user = User.find(params[:user_id])
  	notification = Notification.find(params[:id])
  	notification.destroy
  	redirect_to user_notifications_path(@user)
  end

end
