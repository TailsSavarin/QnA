require 'rails_helper'

feature 'User can add link to answer', %q(
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:test_url) { 'https://www.google.com' }
  given!(:answer) { create(:answer, question: question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds links when create answer', js: true do
    fill_in 'Your Answer:', with: 'text text text'

    fill_in 'Name', with: 'Google'
    fill_in 'URL', with: test_url

    click_on 'Post Your Answer'

    within '.answers' do
      expect(page).to have_link 'Google', href: test_url
    end
  end

  scenario 'User adds links when edits his question', js: true do
    click_on 'Edit answer'
    within "#answer-#{answer.id}" do
      click_on 'add link'

      fill_in 'Name', with: 'Google'
      fill_in 'URL', with: test_url

      click_on 'Update answer'

      expect(page).to have_link 'Google', href: test_url
    end
  end
end
