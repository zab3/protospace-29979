class PrototypesController < ApplicationController
  before_action :authenticate_user!, except:[:index,:show,:edit]
  before_action :move_to_index, only:[:edit]

  def index
    @prototype = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    prototype = Prototype.create(prototype_create_params)
    if prototype.save
      redirect_to root_path
    else
      render :new
    end
  end       

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
    
  end
  
  def edit
    @prototype = Prototype.find(params[:id])
    unless @prototype.user_id == current_user.id 
      redirect_to action: :index
    end
  end

  def update
    prototype = Prototype.find(params[:id])
    if prototype.update(prototype_edit_params)
       redirect_to prototype_path(prototype.id)
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_create_params
    params.permit(:title,:catch_copy,:concept,:image).merge(user_id: current_user.id)
  end

  def prototype_edit_params
    params.require(:prototype).permit(:title,:catch_copy,:concept,:image).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

end
