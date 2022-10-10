class Api::V1::User::RecordsController < ApplicationController
  def index
    succeeded_results = current_user.trainings.in_month(params[:year], params[:month])
      .joins(:result_words).merge(ResultWord.succeeded)
      .select('date(result_words.created_at) as date, count(*) as count')
      .group('date').order('date asc').to_a
    failed_results = current_user.trainings.in_month(params[:year], params[:month])
      .joins(:result_words).merge(ResultWord.failed)
      .select('date(result_words.created_at) as date, count(*) as count')
      .group('date').order('date asc').to_a
    day = Date.new(params[:year].to_i, params[:month].to_i, -1).day

    monthly_results = []
    1.upto day do |i|
      succeeded_number = 0
      failed_number = 0
      if !succeeded_results.empty? && succeeded_results[0].date.day == i
        succeeded_number = succeeded_results.shift.count
      end
      if !failed_results.empty? && failed_results[0].date.day == i
        failed_number = failed_results.shift.count
      end
      monthly_results << { succeededNumber: succeeded_number, failedNumber: failed_number }
    end

    render json: monthly_results
  end
end
