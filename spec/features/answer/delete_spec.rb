require 'rails_helper'

feature 'User can delete answer', %q(
  If decide that it's necessary
  As an answer's author
  I'd like to be able to delete my answer
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticated user' do
    scenario 'author deletes the answer', js: true do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        click_on 'Delete Answer'
        page.driver.browser.switch_to.alert.accept

        expect(page).not_to have_content(answer.body)
      end
    end

    scenario 'not author tries to delete the answer' do
      sign_in(another_user)
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link 'Delete Answer'
      end
    end
  end

  scenario 'unauthenticated user can not delete the answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Delte Answer'
    end
  end
end
