require 'slack-ruby-bot'

class BDDNotifier
  def initialize
    Slack.configure do |config|
      config.token = ENV['BDD_BOT_SLACK_TOKEN']
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
    message = "Build ##{build} of #{repo} failed. Please check: "
    travis_link = "https://travis-ci.org/CBIIT/nci-uMatch-bddtests/jobs/#{job_id}"
    travis_link = "<#{travis_link}|Travis Log>"
    message += "\n#{travis_link} or "
    today_date = Date.today.strftime('%m-%d-%y')
    bdd_report_link = 'http://pedmatch-admin-alb-external-382939701.us-east-1.elb.amazonaws.com:3025'
    bdd_report_link = "#{bdd_report_link}/report/#{today_date}/critical/#{cuc_tag.gsub('@', '')}"
    bdd_report_link = "<#{bdd_report_link}|BDD Test Report>"
    message += "#{bdd_report_link}"
    say(message, git_user)
  end
end

# BDDNotifier.new.notify_bdd_failure('LiWang', 'nci-match-patient-api', '01-09-17-1048', '@ui', "190292979")