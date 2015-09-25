class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
  end

  def profile
  end

  def update_profile
    respond_to do |format|
      if @user.update(params.require(:user).permit(:name, :image))
        format.html { redirect_to user_path(@user), notice: 'User was successfully updated.' }
      else
        format.html { render :profile }
      end
    end
  end
end
