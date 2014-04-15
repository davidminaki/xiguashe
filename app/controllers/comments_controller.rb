class CommentsController < ApplicationController
  
  before_filter :logined?
  
  def new
    @comment = Comment.new
  end

  def create

    model_hash = {
                  topic_id: 'Topic|topic',
                  product_id: 'Product|product'
                 }

    for key,value in model_hash do
      model_id = eval("params[:#{key}]")
      if model_id
        model_info = value.split('|')
        model_name = model_info.first
        model_instance = Object.const_get(model_name).find(model_id)
        
        @comment = Comment.create(:content => params[:comment][:content].gsub(/\r\n/,"<br/>"),
                                   :user_id => params[:comment][:user_id],
                                   :commentable => model_instance)

        if @comment.save

          model_instance.update_attributes({:reply_num => model_instance.reply_num + 1})
          
          eval("@#{model_info.last} = model_instance")

          page = (model_instance.comments.count / Comment.per_page) + 1

          redirect_to  "/#{model_info.last}s/#{model_instance.id}?page=#{page}##{@comment.id}", :notice => t(:comment_create_success)

        else
          message = ''
          @comment.errors.full_messages.each do |msg|
            message << msg
          end
          flash[:notice] = message
          redirect_to  model_instance
        end

        break

      end 
    end
  end

  def reply_create
    @reply = Comment.create(:content => params[:reply][:content],
                            :user_id => params[:reply][:user_id],
                            :reply_parent_id => params[:id])
    @comment = Comment.find(params[:id])

    if @reply.save
      
    end

  end

  def get_comment_user

    if params[:commentable_type] == "Topic"

      commentable = Topic.find(params[:commentable_id])

    elsif params[:commentable_type] == "Product"

      commentable = Product.find(params[:commentable_id])

    else

      return

    end

		
		users = []

		commentable.comments.each do |comment|
			users << [comment.user.id, comment.user.nickname] unless comment.user.id == commentable.user.id
		end 

		render json: users.uniq

	end

  private 
    


end
