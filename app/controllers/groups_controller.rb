class GroupsController < ApplicationController
  def index
  end

  def new
  	@group = Group.new
  end

  def create
  	@group =  Group.new params[:group]

  	if @group.save
  		redirect_to groups_path,:notice  => 'create_group_success'
  	else
  		render 'new'
  	end
  end

  def show
  	
  end



end