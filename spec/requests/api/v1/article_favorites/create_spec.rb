require 'rails_helper'

RSpec.describe 'Api::V1::ArticleFavorites', type: :request do
  # POST /api/v1/articles/:id/article_favorites/create(.json) 記事お気に入り作成API(処理)
  # 前提条件
  #   なし
  # テストパターン
  #   未ログイン, ログイン中, APIログイン中
  #   無効なパラメータ, 有効なパラメータ
  describe 'POST #create' do
    subject { post api_v1_favorite_article_path(id: article.id, format: :json), params: attributes, headers: auth_headers }
    let_it_be(:article_favorite) { FactoryBot.attributes_for(:article_favorite) }
    let_it_be(:article) { FactoryBot.create(:article) }
    let(:valid_attributes) { { article_favorite: { article_id: article_favorite[:article_id], user_id: article_favorite[:user_id] } } }
    let(:invalid_attributes) { nil }
    let(:current_user) { user }

    # テスト内容
    shared_examples_for 'OK' do
      it '作成される。' do
        expect { subject }.to change(ArticleFavorite, :count).by(1) && change(PointRecord, :count).by(2) && change(Infomation, :count).by(1)
      end
    end

    shared_examples_for 'NG' do
      it '作成されない。' do
        expect { subject }.to change(ArticleFavorite, :count).by(0) && change(PointRecord, :count).by(0) && change(Infomation, :count).by(0)
      end
    end

    shared_examples_for 'ToMsg' do |code, success, alert, notice|
      it "HTTPステータスが#{code}。対象項目が一致する。" do
        is_expected.to eq(code)
        response_json = response.body.present? ? JSON.parse(response.body) : {}
        expect(response_json['success']).to eq(success)

        expect(response_json['alert']).to alert.present? ? eq(I18n.t(alert)) : be_nil
        expect(response_json['notice']).to notice.present? ? eq(I18n.t(notice)) : be_nil
      end
    end

    # テストケース
    shared_examples_for '[未ログイン/ログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]無効なパラメータ' do
      let(:attributes) { invalid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 422, false, 'alert.article_favorite.create', nil
    end

    shared_examples_for '[未ログイン/ログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'NG'
      it_behaves_like 'ToMsg', 401, false, 'devise.failure.unauthenticated', nil
    end

    shared_examples_for '[APIログイン中]有効なパラメータ' do
      let(:attributes) { valid_attributes }
      it_behaves_like 'OK'
      it_behaves_like 'ToMsg', 200, true, nil, 'notice.article_favorite.create'
    end

    context '未ログイン' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
    end

    context 'ログイン中' do
      include_context '未ログイン処理'
      it_behaves_like '[未ログイン/ログイン中]無効なパラメータ'
      it_behaves_like '[未ログイン/ログイン中]有効なパラメータ'
    end

    context 'APIログイン中' do
      include_context 'APIログイン処理'
      # it_behaves_like '[APIログイン中]無効なパラメータ'
      it_behaves_like '[APIログイン中]有効なパラメータ'
    end
  end
end
