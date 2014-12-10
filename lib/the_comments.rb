_root_ = File.expand_path('../../',  __FILE__)

require 'state_machine'
require 'state_machine/version'

require 'the_simple_sort'
require 'the_notification'
require 'the_sortable_tree'

require 'the_comments/config'
require 'the_comments/version'

require 'the_viking'
require 'yandex_cleanweb'

module TheComments
  class Engine < Rails::Engine
    _root_ = config.root

    # http://stackoverflow.com/questions/24244519
    #
    # 1. Removing all the require / require_relative
    # 2. Add needed paths to Rails autoload paths
    # 3. Put files at the right places with the right names so Rails can infer where to look for code to load.

    # Model concerns loading
    %w[ user comment commentable comment_subscription akismet yandex_cleanweb anti_spam  ].each do |file_name|
      config.autoload_paths << "#{ _root_ }/app/models/concerns/the_comments/#{ file_name }"
    end

    # Controllers concerns loading
    %w[ view_token controller manage_actions spam_traps ].each do |file_name|
      config.autoload_paths << "#{ _root_ }/app/controllers/concerns/the_comments/#{ file_name }"
    end
  end

  # simple and almost perfect
  # anything[at]anything[dot]anything{2-15}
  EMAIL_REGEXP = /\A(\S+)@(\S+)\.(\S{2,15})\z/
end

# Routing cocerns loading
require "#{ _root_ }/config/routes"

if StateMachine::VERSION.to_f <= 1.2
  puts '~' * 50
  puts 'WARNING!'
  puts '~' * 50
  puts 'TheComments >>> StateMachine patch for Rails 4 will be applied'
  puts
  puts '> private method *around_validation* from StateMachine::Integrations::ActiveModel will be public'
  puts
  puts 'https://github.com/pluginaweek/state_machine/issues/295'
  puts 'https://github.com/pluginaweek/state_machine/issues/251'
  puts '~' * 50
  module StateMachine::Integrations::ActiveModel
    public :around_validation
  end
end
