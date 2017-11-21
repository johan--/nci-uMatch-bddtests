require_relative 'utilities'
require_relative 'log'

class GeneralStory
  STORY_TABLE = 'test_management_seed_story'
  STORY_SERVICE = "#{ENV['TEST_MANAGEMENT_URL']}/seed_story"

  def self.all_seed_data(project)
    JSON.parse(Utilities.rest_request("#{STORY_SERVICE}_ids/#{project}", 'get'))
  end

  def initialize(data_id, project, category)
    @data_id = data_id
    @project = project
    @category = category
    load
  end

  def full_story
    @story_hash
  end

  def create_seed_story
    @story_hash.clear
    yield
    save
  end

  def create_temporary_story
    @story_hash.clear
    yield
  end

  def exist?
    @exist
  end

  def save
    headers = {:content_type => 'application/json', :accept => 'application/json'}
    url = "#{STORY_SERVICE}/#{@project}/#{@category}/#{@data_id}"
    response = Utilities.rest_request(url, 'post', @story_hash, headers)
    if response.code == 200
      @exist = true
      Log.info("#{@data_id} has been written to database")
    else
      @exist = false
      Log.error("Seed data service failed when input #{@data_id} to database")
    end
  end

  def load
    query = JSON.parse(Utilities.rest_request("#{STORY_SERVICE}/#{@data_id}", 'get'))
    if query.size == 1
      @exist = true
      @story_hash = query[0]['story']
    else
      @exist = false
      @story_hash = []
    end
  end

  def data_id
    @data_id
  end

  private :load
end