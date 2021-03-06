# app/workers/tweet_worker.rb
class TweetWorker
  include Sidekiq::Worker

  def perform(tweet_id)
    tweet = Tweet.find(tweet_id)
    user = tweet.user

    # set up Twitter OAuth client here
    # actually make API call
    # Note: this does not have access to controller/view helpers
    # You'll have to re-initialize everything inside here

    client = Twitter::REST::Client.new do |config|
          config.consumer_key = API_KEYS["twitter_consumer_key_id"]
          config.consumer_secret = API_KEYS["twitter_consumer_secret_key_id"]
          config.access_token = user.oauth_token
          config.access_token_secret = user.oauth_secret
    end
    client.update(tweet.status)
  end
end
