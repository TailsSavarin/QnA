require 'rails_helper'

feature 'Author of the question can delete attached files', %q(
  In order to delete excess or unnecessary files
  As an author
  I'd like to be able to delete attached files
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'author tries to delete attached files from his question', js: true do
    sign_in(user)
    question.files.attach(create_file_blob(filename: 'test.jpg'))
    visit question_path(question)
    within '.question' do
      expect(page).to have_content 'test.jpg'
      click_on 'Delete file'
      page.driver.browser.switch_to.alert.accept
      expect(page).to_not have_link 'Delete file'
      expect(page).to_not have_content 'test.jgp'
    end
  end
  scenario 'non author tries to delete attache files from the question'
end
