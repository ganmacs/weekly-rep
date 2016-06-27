class HomeController < ApplicationController
  before_action :check_do_or_die!, only: [:index]
  before_action :validate_user!, only: [:index]

  def index
    @reports = current_user.group.weekly_reports.where(published: true).includes(:user)
    @reports = @reports.where('reported_time > ?', 1.week.ago).order('updated_at DESC')
  end

  def do_or_die
  end

  def join_group
  end

  private

  def validate_user!
    return if current_user.approved_user?
    redirect_to action: 'join_group'
  end

  def check_do_or_die!
    return if user_signed_in?
    redirect_to action: 'do_or_die'
  end
end
