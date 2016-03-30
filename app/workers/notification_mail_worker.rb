class NotificationMailWorker
  include Sidekiq::Worker

  def perform(reporting_time)
    groups = Group.where reporting_time: reporting_time
    groups.each do |group|
      group.users.each do |user|
        NotificationMailer.notification_mail(user).deliver_later #メール送信
        p user.name + "にメールを送りました"
      end

      group.update_reporting_time
    end

    NotificationMailWorker.set_next_job
  end

  class << self
    def set_next_job
      delete_jobs
      make_next_job
    end

    def delete_jobs
      Sidekiq::ScheduledSet.new.select do |s|
        s.item['class'] == 'NotificationMailWorker'
      end.map(&:delete)
    end

    def make_next_job
      next_reporting_time = Group.minimum :reporting_time
      perform_at(next_reporting_time, next_reporting_time)
    end
  end
end