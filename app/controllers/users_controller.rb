class UsersController < ApplicationController
  before_action :authenticate_no_user_or_guest!

  def show
  end

  def profile
  end

  def update_profile
    respond_to do |format|
      if current_user.update(params.require(:user).permit(:name, :image))
        format.html { redirect_to users_path(@user), notice: 'プロフィールを更新しました' }
      else
        format.html { render :profile }
      end
    end
  end

  def delivery
  end

  def update_delivery
    respond_to do |format|
      if current_user.update(params.require(:user).permit(:address, :zip_code, :phone_number))
        format.html { redirect_to users_path(@user), notice: '配送先を更新しました' }
      else
        format.html { render :profile }
      end
    end
  end
end
