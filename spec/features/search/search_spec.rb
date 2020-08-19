require 'sphinx_helper'

feature 'User can use search', "
  In order to find information he needs
  As guest
  I'd like to be able to use search
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:question_comment) { create(:comment, commentable: question) }

  background { visit root_path }

  scenario 'user searchs All', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.input-group' do
        fill_in :query, with: ''
        select 'All', from: :resource
        click_on 'Search'
      end

      expect(page).to have_content user.email
      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content question_comment.body
    end
  end

  scenario 'user searchs Question', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.input-group' do
        fill_in :query, with: question.title
        select 'Question', from: :resource
        click_on 'Search'
      end

      expect(page).to have_content '1 result'
      expect(page).to have_content question.title
    end
  end

  scenario 'user searchs Answer', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.input-group' do
        fill_in :query, with: answer.body
        select 'Answer', from: :resource
        click_on 'Search'
      end

      expect(page).to have_content '1 result'
      expect(page).to have_content answer.body
    end
  end

  scenario 'user searchs Comment', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.input-group' do
        fill_in :query, with: question_comment.body
        select 'Comment', from: :resource
        click_on 'Search'
      end

      expect(page).to have_content '1 result'
      expect(page).to have_content question_comment.body
    end
  end

  scenario 'user searchs User', sphinx: true do
    ThinkingSphinx::Test.run do
      within '.input-group' do
        fill_in :query, with: user.email
        select 'User', from: :resource
        click_on 'Search'
      end

      expect(page).to have_content '1 result'
      expect(page).to have_content user.email
    end
  end
end
