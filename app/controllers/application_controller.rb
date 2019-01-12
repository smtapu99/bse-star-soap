class ApplicationController < ActionController::API
  #SOAP request
  # https://github.com/savonrb/savon
  require 'savon'

  include BseSettingsHelperHelper
  include LogHelper

end
