class NewsMailer < ActionMailer::Base
  def news_created(news, username, mailing_list)
  	@news = news
  	@username = username

  	mail(
  		to: mailing_list,
  		from: "burse-fmi@mydomain.com",
  		subject: "Informatii sesiune de burse"
  	)
  end
end
