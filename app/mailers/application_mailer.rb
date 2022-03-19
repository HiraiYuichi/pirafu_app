class ApplicationMailer < ActionMailer::Base
   # 送信元のメールアドレスを設定
  default from: "from@example.com"
  layout "mailer"
end
