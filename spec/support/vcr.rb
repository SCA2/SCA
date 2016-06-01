require 'vcr'

VCR.configure do |config|
  config.ignore_localhost = true
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].
      split(/\s+/, 2).join("/").
      underscore.gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).
      except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end
end