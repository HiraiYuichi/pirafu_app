class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def show
    @user = User.find(params[:id])
  end
# def destroy
 #   User.find(params[:id]).destroy
   # flash[:success] = "User deleted"
  #  redirect_to users_url
  #end
  def index
    #@users =  User.all
    @users = User.page(params[:page]).per(10)
  end
  
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
        # Userモデルで定義したメソッド（send_activation_email）を呼び出して有効化メールを送信
        
        UserMailer.with(user: @user).welcome_email.deliver_later
      #@user.send_activation_email
       flash[:info] = "メールを確認してアカウントを有効にしてください。"
       redirect_to root_url
    else
      render 'new' 
    end
  end
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
     # 正しいユーザーかどうか確認
     def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

      #許可された属性リストにadminが含まれていない=adminは編集できない！
      def user_params
        params.require(:user).permit(:name, :email, :password,
                                     :password_confirmation)
      end

       # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
