require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do
    before { question.files.attach(create_file_blob) }

    let(:file) { question.files.first }
    let(:files) { question.files }

    context 'authenticated user' do
      context 'author' do
        before { login(user) }

        it 'deletes file from the database' do
          expect {
            delete :destroy, params: { id: file }, format: :js
          }.to change(files, :count).by(-1)
        end

        it 'renders destroy view template' do
          delete :destroy, params: { id: file }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'non author' do
        before { login(another_user) }

        it 'dose not delete file from the database' do
          expect {
            delete :destroy, params: { id: file }, format: :js
          }.to_not change(files, :count)
        end

        it 'renders destroy view template' do
          delete :destroy, params: { id: file }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not delete file from the database' do
        expect {
          delete :destroy, params: { id: file }, format: :js
        }.to_not change(files, :count)
      end

      it 'responses with status 401' do
        delete :destroy, params: { id: file }, format: :js
        expect(response.status).to eq(401)
      end
    end
  end
end
