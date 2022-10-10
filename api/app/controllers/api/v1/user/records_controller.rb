class Api::V1::User::RecordsController < ApplicationController
  def index
    succeeded_results = current_user.trainings.in_month(params[:year], params[:month]).succeeded_counts
    failed_results = current_user.trainings.in_month(params[:year], params[:month]).failed_counts
    day = Date.new(params[:year].to_i, params[:month].to_i, -1).day

    monthly_results = []
    1.upto day do |i|
      succeeded_number = calculate_word_count(succeeded_results, i)
      failed_number = calculate_word_count(failed_results, i)

      monthly_results << { succeededNumber: succeeded_number, failedNumber: failed_number }
    end

    render json: monthly_results
  end

  private

  def calculate_word_count(results, day)
    if !results.empty? && results[0].date.day == day
      results.shift.count
    else
      0
    end
  end
end
