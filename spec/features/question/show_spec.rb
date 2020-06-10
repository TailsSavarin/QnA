require 'rails_helper'

feature 'User can watch the question and answers to it', %q(
  In order to get the information that interests him
  As an user
  I'd like to be able to view the question and answers to it
) do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  scenario 'User trie to watch the question and answers to it' do
    visit question_path(question)
    save_and_open_page
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end
