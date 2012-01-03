Gem::Specification.new do |s|
  s.name = 'acts_as_retired'
  s.version = '1.0.0'
  s.author = 'Andrew Coleman'
  s.email = 'developers@consoloservices.com'
  s.summary = 'Acts As Retired'
  s.description = 'Instead of destroying active record objects, mark a column as deleted with a timestamp'
  s.homepage = 'https://redmine.consoloservices.com'
  s.require_path = '.'
  s.files = [ 'acts_as_retired.rb' ]
  s.add_dependency 'activerecord', '~> 2.3'
end
