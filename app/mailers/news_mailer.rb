class NewsMailer < ActionMailer::Base
  def news_created(news, username)
  	@news = news
  	@username = username

  	mail(
  		to: ["axintemihnea@yahoo.com", "teodora.cernea@yahoo.com", "bogdan.mihai.timofte@gmail.com", "dragos.tudorache91@gmail.com"],
  		from: "burse-fmi@mydomain.com",
  		subject: "Noutati burse!"
  	)
  end
end
