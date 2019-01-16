class ApplicationController < ActionController::API
  #SOAP request
  # https://github.com/savonrb/savon
  require 'savon'

  include BseSettingsHelper
  include ApplicationHelper
  include LogHelper

end
