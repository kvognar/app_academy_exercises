class PostsController < ApplicationController
  before_action :ensure_logged_in!, only: [:new, :create, :edit, :update]
  
  def new
    @post = Post.new(sub_ids: [params[:id]])
    @subs = Sub.all
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.author = current_user
    if @post.save
      redirect_to post_url(@post)
    else
      render :new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @subs = Sub.all
    render :edit
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      redirect_to post_url(@post)
    else
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    @subs = @post.subs
    @comments = @post.comments_by_parent_id     
    render :show
  end
  
  private
  def post_params
    params.require(:post).permit(:title, :url, :content, sub_ids: [])
  end
end
