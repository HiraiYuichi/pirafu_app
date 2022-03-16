class SessionsController < ApplicationController
  def new
  end
  #loginフォームで「ログインする」ボタンを押すと
  #createアクションが実行され「sessions/new.html.erb」が描画される
  def create
    #userに代入　Userモデルから指定した条件の最初の1件を取得
    #条件→（emailカラム内にある　postされたsessionが持つemailの値と合致するデータをすべて小文字にしたもの）
    @user = User.find_by(email: params[:session][:email].downcase)
    #userが存在する　かつ　postされたsessionが持つパスワードがそのuserのものと一致する
    if @user && @user.authenticate(params[:session][:password])
       # userが有効であれば
       if @user.activated?
        #session[:user_id] = @user　と言う事
        log_in @user
        # params[:session][:remember_me]が1の時@userを記憶　そうでなければuserを忘れる
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        #SessionsHelperで定義したredirect_back_orメソッドを呼び出してリダイレクト先を定義
        redirect_back_or @user
      else
        message  = t('.account_not_activated')
        message += t('.check_your_email')
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールとパスワードの組み合わせが無効です'
      render 'new'
    end
  end
  def destroy
     #ログアウトする（sessions_helperのlog_outメソッド
     log_out if logged_in?
    #ルートURLにリダイレクト
    redirect_to    root_url
  end
end
