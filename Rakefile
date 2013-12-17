$:.unshift File.expand_path("../lib", __FILE__)
require 'rake'
require "bundler/gem_tasks"
require 'pragprog_kata08'

def normalize_time!(time)
  time.strftime("%m/%d/%Y at %I:%M %p")
end

def timer
  started_at  = Time.now
  yield
  finished_at = Time.now
  time = finished_at - started_at
  print "Done in: #{time} - #{normalize_time!(finished_at)}\n"
end

desc "Returns list of matched words\n Default list is /usr/share/dict/words\n
If you'd like to pass your own list you can do so like this:\n
rake path=absolute_path_to_my_word_list"
task :run do |opt|
  timer { PragprogKata08::Runner.run }
end

task default: :run
