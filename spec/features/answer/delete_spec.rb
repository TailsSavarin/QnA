require 'rails_helper'

feature 'Author can delete his answer', %q(
  If cinsider it necessary
  As an author
  I'd like to be able to delete my answer
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'author tries to delete his answer', js: true do
    sign_in(user)
    visit question_path(question)
    within '.answers' do
      click_on 'Delete answer'
      page.driver.browser.switch_to.alert.accept
      expect(page).not_to have_content(answer.body)
    end
  end

  scenario 'non author tries to delete the answer', js: true do
    sign_in(another_user)
    visit question_path(question)
    within '.answers' do
      expect(page).not_to have_link 'Delete answer'
    end
  end
end
