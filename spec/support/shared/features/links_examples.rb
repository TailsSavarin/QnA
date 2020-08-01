shared_examples 'links features', :js do
  given(:bad_url) { 'www.google.com' }
  given(:good_url) { 'https://www.google.com' }
  given(:gist_url) { 'https://gist.github.com/TailsSavarin/2d313a9ece10a0c17cb3decee000e294' }

  background do
    sign_in(user)
    background_i
  end

  scenario 'adds link with valid data' do
    within linkable_selector.to_s do
      click_on 'Add Link'
      fill_in 'Link Name', with: 'Google'
      fill_in 'Link URL', with: good_url
    end

    linkable_btn

    expect(page).to have_link 'Google', href: good_url
  end

  scenario 'adds link with invalid data' do
    within linkable_selector.to_s do
      click_on 'Add Link'
      fill_in 'Name', with: 'Google'
      fill_in 'URL', with: bad_url
    end

    linkable_btn

    expect(page).to have_content 'Links url is invalid'
  end

  scenario 'adds link gist' do
    within linkable_selector.to_s do
      click_on 'Add Link'
      fill_in 'Name', with: 'Gist'
      fill_in 'URL', with: gist_url
    end

    linkable_btn

    expect(page).to have_content 'test-guru-question.txt hosted with ❤ by GitHub'
  end
end
