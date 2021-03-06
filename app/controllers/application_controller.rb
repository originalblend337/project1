class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user, :signed_in?, :list_tags, :authorize_post, :authorize_comment

  private

  def current_user
  	User.find_by :github_access_token => session[:github_access_token]
  end

  def signed_in?
    redirect_to root_path if !current_user
  end

  def client
    Octokit::Client.new(access_token: current_user.github_access_token)
  end

  def list_tags(tags)
    tag_list = Array.new
    tags.each { |tag| tag_list << tag.name }
    tag_list.join(" ")
  end

  def new_post
    current_user.posts.new
  end

  def authorize_post
    post = Post.find(params[:id])
    redirect_to posts_path if post.user != current_user
  end

  def authorize_comment
    comment = Comment.find(params[:id])
    redirect_to posts_path if comment.author != current_user
  end
end
