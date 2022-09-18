json.success true

if current_user.present?
  json.stocks do
    json.array! TaskProfile.stock_tasks.pairs.zip(@sum_stocks) do |task, stock|
      json.name task[0]
      json.value task[1]
      json.count stock[1]
      json.is_completed @task_profile.stock_tasks.set?(task[1]) if @task_profile.present?
    end
  end
  # json.sns_task_complete current_user.sns_tasks.raw == 2097151
end
