

class User < ActiveRecord::Base

  has_many :tweets


  def access_token?
    if self.oauth_token && self.oauth_secret
      true
    else
      false
    end
  end

  def authenticate? (password)
    self.password == password ? true : false
  end

  def tweet(status)
    tweet = tweets.create!(status: status, user: self)

    #Sidekiq will return jobid
    job_id = TweetWorker.perform_async(tweet.id)
  end

  def tweet_delay_5minute(status)
    tweet = tweets.create!(status: status, user: self)
    #Sidekiq will return jobid
    job_id = TweetWorker.perform_in(5.minutes, tweet.id)
  end


end