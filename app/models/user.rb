class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :group
  has_many :weekly_reports

  def approved_user?
    joined_group? && approved?
  end

  def joined_group?
    !!group_id
  end

  def latest_report_published?
    weekly_reports.find_by(reported_time: group.latest_reported_time, published: true)
  end

  def next_draft
    next_reporting_time = group.reporting_time
    weekly_reports.find_by(reported_time: next_reporting_time, published: false)
  end

  def latest_draft
    weekly_reports.find_by(reported_time: group.latest_reported_time, published: false)
  end
end
