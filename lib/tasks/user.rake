namespace :user do
  desc '削除予定日時を過ぎたユーザーのアカウントを削除'
  task destroy: :environment do
    logger = Logger.new("log/user_destroy_#{Rails.env}.log")
    logger.info('=== START ===')

    users = User.by_destroy_reserved
    logger.debug(users)

    count = users.count
    logger.info("count: #{count}")

    users.find_each.with_index(1) do |user, index|
      logger.info("[#{index}/#{count}] id: #{user.id}, destroy_schedule_at: #{user.destroy_schedule_at}")
      raise '削除予定日時が不正' if user.destroy_schedule_at > Time.current

      unless user.destroy
        logger.error('削除失敗')
        next
      end
    end

    logger.info('=== END ===')
  end
end
