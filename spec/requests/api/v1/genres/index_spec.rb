require 'rails_helper'

RSpec.describe 'Api::V1::Genres', type: :request do
  # GET /api/v1/genres(.json) ジャンル一覧API
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  describe 'GET #index' do
    subject { get api_v1_genres_path(format: :json), headers: auth_headers }

    shared_context 'ジャンル・記事一覧作成' do
      let_it_be(:current_user) { user }
      let_it_be(:genres) { FactoryBot.create_list(:genre, Settings['default_index_limit']) }
    end

    # テスト内容
    shared_examples_for 'ToOK' do
      it 'HTTPステータスが200。件数・対象項目が一致する' do
        is_expected.to eq(200)
        expect(JSON.parse(response.body)['success']).to eq(true)

        response_json = JSON.parse(response.body)['genres']

        all = Settings['default_index_limit']
        expect(response_json.count).to eq(all)
        (1..all).each do |no|
          data = response_json[no - 1]
          genre = genres[no - 1]
          expect(data['id']).to eq(genre.id)
          expect(data['name']).to eq(genre.name)
          expect(data['icon']).to eq(genre.icon)
          expect(data['image_url']['large']).to eq("#{genre.image_url(:large)}")
          expect(data['image_url']['xlarge']).to eq("#{genre.image_url(:xlarge)}")
          expect(data['image_url']['xxlarge']).to eq("#{genre.image_url(:xxlarge)}")
        end
      end
    end
    # shared_examples_for 'ToNot' do |success, alert, notice|
    #   it 'HTTPステータスが401。対象項目が一致する' do
    #     is_expected.to eq(401)
    #     response_json = response.body.present? ? JSON.parse(response.body) : {}
    #     expect(response_json['success']).to eq(success)

    #     expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
    #     expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
    #   end
    # end

    # テストケース
    context '未ログイン' do
      include_context '未ログイン処理'
      include_context 'ジャンル・記事一覧作成'
      it_behaves_like 'ToOK'
    end
    context 'ログイン中' do
      include_context 'ログイン処理'
      include_context 'ジャンル・記事一覧作成'
      it_behaves_like 'ToOK'
    end
    context 'APIログイン中' do
      include_context 'APIログイン処理'
      include_context 'ジャンル・記事一覧作成'
      it_behaves_like 'ToOK'
    end
  end
end
