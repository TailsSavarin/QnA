require 'rails_helper'

feature 'User can add comments to question', %q(
  In order to clarify information or correct the author
  As an authenticated user
  I'd like to be able to add comments
) do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'comments on the question' do
      click_on 'Add a comment'

      fill_in :comment_body, with: 'Test comment'

      click_on 'Post Your Comment'

      expect(page).to have_content 'Test comment'
    end

    scenario 'comments on the question with errors' do
      click_on 'Add a comment'
      click_on 'Post Your Comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'unauthenticated user can not comments on the question' do
    visit question_path(question)
    expect(page).to_not have_link 'Add a comment'
  end

  context 'multiple sessions' do
    scenario 'comment appears on another user page', js: true do
      Capybara.using_session('authenticated_user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('unauthenticated_user') do
        visit question_path(question)
      end

      Capybara.using_session('authenticated_user') do
        click_on 'Add a comment'

        fill_in :comment_body, with: 'Test comment'

        click_on 'Post Your Comment'

        within "#question-#{question.id}-comments" do
          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('unauthenticated_user') do
        expect(page).to have_content 'Test comment'
      end
    end
  end
end
