# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ReportsController < Api::V1::BaseController
        def index
          authorize :admin, :reports?

          range = params.fetch(:range, 'daily')
          report_data = Reports::SalesReport.new(range:).call

          render_success(data: report_data)
        end
      end
    end
  end
end
