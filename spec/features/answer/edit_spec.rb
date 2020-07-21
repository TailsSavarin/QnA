require 'rails_helper'

feature 'User can edit his answer', %q(
  In order to supplement a answer or correct errors
  As an answer's author
  I'd like to be able to edit my answer
) do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticated user' do
    context 'author', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'edits the answer' do
        within '.answers' do
          click_on 'Edit Answer'

          fill_in 'Change Answer', with: 'Edited body'

          click_on 'Update Your Answer'

          expect(page).to_not have_content answer.body
          expect(page).to_not have_selector 'textarea'
          expect(page).to have_content 'Edited body'
        end
      end

      scenario 'edits the answer with errors' do
        within '.answers' do
          click_on 'Edit Answer'

          fill_in 'Change Answer', with: nil

          click_on 'Update Your Answer'

          expect(page).to have_content "Body can't be blank"
        end
      end

      scenario 'adds attached files while edit the answer' do
        within '.answers' do
          click_on 'Edit Answer'

          attach_file 'File', [
            Rails.root / 'spec' / 'fixtures' / 'files' / 'test.jpg',
            Rails.root / 'spec' / 'fixtures' / 'files' / 'test.png'
          ]

          click_on 'Update Your Answer'

          expect(page).to have_content 'test.jpg'
          expect(page).to have_content 'test.png'
        end
      end
    end

    scenario 'not author tries to edit the answer' do
      sign_in(another_user)
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link 'Edit Answer'
      end
    end
  end

  scenario 'unauthenticated user can not edit the answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Edit Answer'
    end
  end
end
