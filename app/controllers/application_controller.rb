class ApplicationController < ActionController::Base
  include Authentication
  helper TimeSelectHelper
  # Allow all browsers including mobile browsers
  # If you want to restrict specific old browsers, use:
  # allow_browser versions: { chrome: 94, firefox: 91, safari: 14 }
end
