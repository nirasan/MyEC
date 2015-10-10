class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :store_location

  helper_method :guest_user?, :current_or_guest_user

  protected

  # ログインしている場合は、 current_userを返す / していない場合は guest_user を返す
  # current_userを置き換えることにより、Guestと通常のユーザーを透過的に扱えるようになる
  def current_or_guest_user
    if current_user
      if session[:guest_user_id] && session[:guest_user_id] != current_user.id
        logging_in
        guest_user(with_retry = false).try(:destroy)
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  # 現在のセッションと関連づく guest_user オブジェクトを探す
  def guest_user(with_retry = true)
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
  end

  def guest_user?
    current_user && current_user.guest?
  end

  # ログインしていない、もしくは、Guestユーザーの場合、ルートにリダイレクトする
  def authenticate_no_user_or_guest!
    redirect_to root_url if current_user.nil? || guest_user?
  end

  # ユーザーがログインした際に一度だけ呼ばれる
  # 通常のユーザーが作成され、Guestユーザーは削除されるので、
  # Guest時に作成したデータを通常のユーザーに渡すなどの処理をする
  def logging_in
    # taskのuser_idをGuestから通常のユーザーに移す
    guest_user.move_to(current_user)
  end

  # Guestユーザーを作成する
  def create_guest_user
    guest = User.new_guest
    guest.save!(:validate => false)
    session[:guest_user_id] = guest.id
    guest
  end

  def store_location
    # 今回の場合は、 /users/sign_in , /users/sign_up, /users/password にアクセスしたとき、ajaxでのやりとりはsessionには保存しない。
    if (request.fullpath != "/users/sign_in" && \
        request.fullpath != "/users/sign_up" && \
        request.fullpath != "/users/password" && \
        !request.xhr?) # don't store ajax calls
      session[:previous_url] = request.fullpath
    end
  end

  #ログイン後のリダイレクトをログイン前のページにする場合
  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  #ログアウト後のリダイレクトをログアウト前のページにする場合
  def after_sign_out_path_for(resource)
    session[:previous_url] || root_path
  end
end
