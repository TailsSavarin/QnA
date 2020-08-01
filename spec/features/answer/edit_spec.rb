require 'rails_helper'

feature 'User can edit answer', %q(
  In order to make changes
  As answer's author
  I'd like to be able to edit answer
) do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  shared_examples 'can not edit answer' do
    scenario 'can not see edit answer link' do
      within "#answer-#{answer.id}" do
        expect(page).to_not have_link('Edit Answer')
      end
    end
  end

  context 'as user' do
    context 'as author', :js do
      background do
        sign_in(user)
        visit question_path(question)
        within "#answer-#{answer.id}" do
          click_on 'Edit Answer'
        end
      end

      scenario 'updates answer with valid data' do
        within "#edit-answer-#{answer.id}" do
          fill_in 'Change Answer', with: 'Edited body'
          click_on 'Update Your Answer'
        end

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited body'
      end

      scenario 'updates answer with invalid data' do
        within "#edit-answer-#{answer.id}" do
          fill_in 'Change Answer', with: ''
          click_on 'Update Your Answer'
        end

        expect(page).to have_content 'Body can\'t be blank'
      end
    end

    context 'not author' do
      background do
        sign_in(another_user)
        visit question_path(question)
      end

      it_behaves_like 'can not edit answer'
    end
  end

  context 'as guest' do
    background { visit question_path(question) }

    it_behaves_like 'can not edit answer'
  end
end
