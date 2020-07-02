require 'rails_helper'

feature 'Authenticated user can vote for the question that he liked', %q(
  In order to highlight the question
  As an authenticated user
  I'd like to be able to vote
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'votes up for the question he like' do
      expect(page).to have_link 'Up'
      click_on 'Up'

      expect(page).to have_content '1'
      expect(page).to_not have_link 'Up'
    end

    scenario 'votes down against the question' do
      expect(page).to have_link 'Down'
      click_on 'Down'

      expect(page).to have_content '-1'
      expect(page).to_not have_link 'Down'
    end

    scenario 'revote the question' do
      expect(page).to have_link 'Revote'
      click_on 'Revote'

      expect(page).to have_link 'Up'
      expect(page).to have_link 'Down'
      expect(page).to_not have_link 'Revote'
    end
  end

  scenario 'unauthenticated user can not votes for the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Up'
    expect(page).to_not have_link 'Down'
  end
end
