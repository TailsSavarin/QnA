require 'rails_helper'

feature 'Author can edit his answer', %q(
  In order to supplement a answer or correct errors
  As an author of answer
  I'd like to be able to edit my answer
) do
  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to edit his answer' do
      within '.answers' do
        click_on 'Edit answer'
        fill_in 'Change answer', with: 'Edited body'
        click_on 'Update answer'
        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector 'textarea'
        expect(page).to have_content 'Edited body'
      end
    end

    scenario 'tires to edit his answer with errors' do
      within '.answers' do
        click_on 'Edit answer'
        fill_in 'Change answer', with: ''
        click_on 'Update answer'
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'can add attached files when edit his answer' do
      within '.answers' do
        click_on 'Edit answer'
        attach_file 'File', [Rails.root / 'spec' / 'rails_helper.rb', Rails.root / 'spec' / 'spec_helper.rb']
        click_on 'Update answer'
        expect(page).to have_content 'rails_helper.rb'
        expect(page).to have_content 'spec_helper.rb'
      end
    end
  end

  scenario 'non author tries to edit answer', js: true do
    sign_in(other_user)
    visit question_path(question)
    within '.answers' do
      expect(page).not_to have_link 'Edit answer'
    end
  end
end
