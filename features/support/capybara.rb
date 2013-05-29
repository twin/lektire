require "capybara"
require "capybara/cucumber"

Capybara.add_selector :record do
  xpath { |record| XPath.css("#" + ActionController::RecordIdentifier.dom_id(record)) }
  match { |record| record.is_a?(ActiveRecord::Base) }
end

module CapybaraHelpers
  def refresh
    visit current_url
  end

  def ensure_on(url)
    visit url unless current_url == url
  end
end

World(CapybaraHelpers)
