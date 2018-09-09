class ReportsController < ApplicationController
  include JsonResponseHelper
  include Reportable

  def show
    json_response(report_data, 200)
  end
end
