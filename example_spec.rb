require 'bundler/setup'
require 'rack/file'
require 'capybara/rspec'
require 'percy/capybara'
require './custom_loader'


RSpec.configure do |config|
  config.include Capybara::DSL
  Capybara.default_driver = :selenium
  Percy::Capybara.use_loader(CustomLoader)
  config.before(:suite) { Percy::Capybara.initialize_build }
  config.after(:suite) { Percy::Capybara.finalize_build }
end

Capybara.app = Rack::File.new File.dirname __FILE__

describe "Example page", :type => :request do
  it "contains an H1 with text 'Hello World!'" do
    visit '/example.html'
    expect(page).to have_css 'h1', :text => 'Hello World!'
    Percy::Capybara.snapshot(page, name: 'Hello World')
  end
end

describe "Click on button, change body", :type => :request do
  it "Body is changed'" do
    visit '/example.html'
    click_button('button')
    Percy::Capybara.snapshot(page, name: 'Button is clicked once')
    click_button('button2')
    Percy::Capybara.snapshot(page, name: 'Button is clicked for the second time')
    expect(find('p')).to have_content('Yet a click, this is also sendt to percy')
  end
end
