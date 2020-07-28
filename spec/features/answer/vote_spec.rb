require 'rails_helper'

feature 'User can vote for the answer that he liked', %q(
  In order to highlight the answer
  As an authenticated user
  I'd like to be able to vote
) do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:another_answer) { create(:answer, question: question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    context 'author' do
      scenario 'can not vote for his anwer' do
        within "#answer-#{answer.id}" do
          expect(page).to_not have_link 'Up'
          expect(page).to_not have_link 'Down'
        end
      end
    end

    context 'not author' do
      scenario 'vote up for the answer' do
        within "#answer-#{another_answer.id}" do
          click_on 'Up'

          expect(page).to have_content '1'
          expect(page).to_not have_link 'Up'
        end
      end

      scenario 'vote down for the answer' do
        within "#answer-#{another_answer.id}" do
          click_on 'Down'

          expect(page).to have_content '-1'
          expect(page).to_not have_link 'Down'
        end
      end

      scenario 're-vote for the answer' do
        within "#answer-#{another_answer.id}" do
          expect(page).to_not have_link 'Revote'
          click_on 'Up'
          click_on 'Revote'

          expect(page).to have_link 'Up'
          expect(page).to have_link 'Down'
          expect(page).to_not have_link 'Revote'
        end
      end
    end
  end

  scenario 'unauthenticated user can not vote for the answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Up'
      expect(page).to_not have_link 'Down'
    end
  end
end