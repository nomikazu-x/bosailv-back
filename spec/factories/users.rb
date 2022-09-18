# == Schema Information
#
# Table name: users
#
#  id                                                            :bigint           not null, primary key
#  allow_password_change(パスワード再設定中)                     :boolean          default(FALSE)
#  confirmation_sent_at(メールアドレス確認送信日時)              :datetime
#  confirmation_token(メールアドレス確認トークン)                :string(255)
#  confirmed_at(メールアドレス確認日時)                          :datetime
#  current_sign_in_at(現在のログイン日時)                        :datetime
#  current_sign_in_ip(現在のログインIPアドレス)                  :string(255)
#  email(メールアドレス)                                         :string(255)      default(""), not null
#  encrypted_password(認証方法)                                  :string(255)      default(""), not null
#  failed_attempts(連続ログイン失敗回数)                         :integer          default(0), not null
#  image(画像)                                                   :string(255)
#  infomation_check_last_started_at(お知らせ確認最終開始日時)    :datetime
#  last_sign_in_at(最終ログイン日時)                             :datetime
#  last_sign_in_ip(最終ログインIPアドレス)                       :string(255)
#  level(レベル)                                                 :integer          default(1), not null
#  lifelong_point(合計獲得ポイント)                              :integer          default(0), not null
#  locked_at(アカウントロック日時)                               :datetime
#  name(氏名)                                                    :string(30)       not null
#  point_to_next(現レベルにおける次のレベルまでに必要なポイント) :integer          default(5), not null
#  power(権限)                                                   :integer          default(NULL), not null
#  profile(自己紹介文)                                           :text(255)
#  provider(認証方法)                                            :string(255)      default("email"), not null
#  remember_created_at(ログイン状態維持開始日時)                 :datetime
#  reset_password_sent_at(パスワードリセット送信日時)            :datetime
#  reset_password_token(パスワードリセットトークン)              :string(255)
#  sign_in_count(ログイン回数)                                   :integer          default(0), not null
#  tokens(認証トークン)                                          :text(65535)
#  uid(UID)                                                      :string(255)      default(""), not null
#  unconfirmed_email(確認待ちメールアドレス)                     :string(255)
#  unlock_token(アカウントロック解除トークン)                    :string(255)
#  username(ユーザーネーム)                                      :string(30)       not null
#  created_at                                                    :datetime         not null
#  updated_at                                                    :datetime         not null
#  city_id(出身市区町村ID)                                       :integer
#  prefecture_id(出身都道府県ID)                                 :integer
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) { |n| "#{n}_" + Faker::Internet.email }
    sequence(:username) { |n| Faker::Internet.user_name(specifier: 'Nancy') + "_#{n}" }
    password { Faker::Internet.password(min_length: 8) }
  end
  
  factory :confirmed_user, class: User do
    name { Faker::Name.name }
    sequence(:email) { |n| "#{n}_" + Faker::Internet.email }
    sequence(:username) { |n| Faker::Internet.user_name(specifier: 'Nancy') + "_#{n}" }
    password { Faker::Internet.password(min_length: 8) }
    confirmed_at { Time.now - 100 }
  end

  factory :guest_user, class: 'User' do
    name { Faker::Name.name }
    sequence(:email) { |n| "#{n}_" + Faker::Internet.email }
    sequence(:username) { |n| Faker::Internet.user_name(specifier: 'Nancy') + "_#{n}" }
    password { ENV['GUEST_USER_PASSWORD'] }
    confirmed_at { Time.now - 100 }
    destroy_schedule_at { Time.current + Settings['destroy_schedule_days'].days }
  end

  factory :admin_user, class: 'User' do
    name { Faker::Name.name }
    sequence(:email) { |n| "#{n}_" + Faker::Internet.email }
    sequence(:username) { |n| Faker::Internet.user_name(specifier: 'Nancy') + "_#{n}" }
    password { Faker::Internet.password(min_length: 8) }
    confirmed_at { Time.now - 100 }
    is_admin { true }
  end
end
