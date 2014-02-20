dirs = %w{ ponominalu }

dirs.each do |dir|
  Dir[File.dirname(__FILE__) + "/#{dir}/*.rb"].each { |f| require f }
end