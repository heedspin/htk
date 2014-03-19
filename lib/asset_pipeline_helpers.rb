require 'action_view/helpers/javascript_helper'
# http://stackoverflow.com/questions/7602173/add-custom-methods-to-rails-3-1-asset-pipeline
module Sprockets::Helpers::RailsHelper
  require Rails.root.join('app', 'helpers', 'deliverable_assets_helper.rb')
  include DeliverableAssetsHelper
	include ActionView::Helpers::JavaScriptHelper
end
