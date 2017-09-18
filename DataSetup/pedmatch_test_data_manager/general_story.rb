require_relative 'utilities'
require_relative 'log'

class GeneralStory
  STORY_TABLE = 'seed_data_story'

  def self.all_seed_data(project)
    Utilities.dynamodb_table_distinct_column(STORY_TABLE, 'data_id', {project:project})
  end

  def initialize(data_id, project)
    @data_id = data_id
    @project = project
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
    Utilities.dynamodb_table_items(STORY_TABLE, {data_id: @data_id}).size == 1
  end

  def save
    item = {
        data_id: @data_id,
        project: @project,
        story: @story_hash
    }
    Utilities.dynamodb_put_item(item, STORY_TABLE)
    Log.info("#{@data_id} has been written to database")
  end

  def load
    query = Utilities.dynamodb_table_items(STORY_TABLE, {data_id: @data_id})
    if query.size == 1
      @story_hash = query[0]['story']
    else
      @story_hash = []
    end
  end

  def data_id
    @patient_id
  end

  private :load
end