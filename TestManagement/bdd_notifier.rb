require 'slack-ruby-bot'

class BDDNotifier
  def initialize
    Slack.configure do |config|
      config.token = ENV['SLACK_TOKEN']
    end

    @client = Slack::Web::Client.new

    @client.auth_test
    @user_list = {}
    @client.users_list['members'].each { |this_member|
      @user_list[this_member['name']] = this_member['id'] }
  end

  def say(word, user)
    @client.chat_postMessage(channel: @user_list[user], text: word, as_user: true)
  end
end

# BDDNotifier.new.say('bdd slack test', 'liwang')