require 'rails_helper'

feature 'User can delete his question', %q(
  If decide that it's necessary
  As an question's author
  I'd like to be able to delete question
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'authenticated user' do
    scenario 'author deletes his question' do
      sign_in(user)
      visit question_path(question)

      click_on 'Delete Question'

      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario 'not author tries to delete the question' do
      sign_in(another_user)
      visit question_path(question)

      expect(page).not_to have_link 'Delete Question'
    end
  end

  scenario 'unauthenticated user can not delete the question' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete Quesiton'
  end
end
