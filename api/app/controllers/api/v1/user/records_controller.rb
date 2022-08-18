class Api::V1::User::RecordsController < ApplicationController
  def index
    trainings = current_user.trainings.in_month(params[:year], params[:month])
      .select('date(created_at) as date, sum(word_count) as sum').group('date').order('date asc').to_a
    result_words = current_user.trainings.in_month(params[:year], params[:month]).joins(:result_words)
      .select('date(result_words.created_at) as date, count(*) as count').group('date').order('date asc').to_a
    day = Date.new(params[:year].to_i, params[:month].to_i, -1).day

    monthly_results = []
    1.upto day do |i|
      succeeded_number = 0
      failed_number = 0
      if !trainings.empty? && trainings[0].date.day == i
        succeeded_number = trainings.shift.sum
      end
      if !result_words.empty? && result_words[0].date.day == i
        failed_number = result_words.shift.count
      end
      monthly_results << { succeededNumber: succeeded_number , failedNumber: failed_number }
    end

    render json: monthly_results
  end
end
