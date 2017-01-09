require 'slack-ruby-bot'

class BDDNotifier
  def initialize
    Slack.configure do |config|
      config.token = ENV['SLACK_TOKEN']
    end

    @client = Slack::Web::Client.new

    @client.auth_test
    @slack_id_dictionary = {}
    @client.users_list['members'].each { |this_member|
      @slack_id_dictionary[this_member['name']] = this_member['id']}
    @slack_user_dictionary = JSON(IO.read('./bdd_notifier_data.json'))['slack_id_dictionary']
  end

  def find_slack_id_from_git_name(git_name)
    @slack_id_dictionary[@slack_user_dictionary[git_name]]
  end

  def say(word, git_user)
    slack_id = find_slack_id_from_git_name(git_user)
    if slack_id.nil? || slack_id.size < 1
      raise "ERROR: Cannot find a slack user id that match git user: #{git_user}!"
    end
    @client.chat_postMessage(channel: slack_id, text: word, as_user: true)
  end

  def notify_bdd_failure(git_user, repo, build, cuc_tag, job_id)
    message = "Build ##{build} of #{repo} failed. Please check report: "
    message += "https://travis-ci.org/CBIIT/nci-uMatch-bddtests/jobs/#{job_id}"
    today_date = "#{Date.today.month.to_s}-#{Date.today.day.to_s}-#{Date.today.year.to_s[2..3]}"
    message += "\nCOMING_SOON/report/#{today_date}/critical/#{cuc_tag.gsub('@', '')}"
    say(message, git_user)
  end
end

# BDDNotifier.new.notify_bdd_failure('LiWang', 'nci-match-patient-api', '01-09-17-1048', '@patients', "190292979")