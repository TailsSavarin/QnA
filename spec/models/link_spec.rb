require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:question) { create(:question) }
  let(:gist_link) do
    create(:link, :for_question, linkable: question, name: 'Gist',
                                 url: 'https://gist.github.com/Test/123')
  end

  describe 'associations' do
    it { should belong_to(:linkable) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:url) }
    it { should allow_values('http://google.com', 'https://google.com').for(:url) }
  end

  describe '#gist?' do
    let(:ordinary_link) { create(:link, :for_question, linkable: question) }

    it 'gist' do
      expect(gist_link).to be_gist
    end

    it 'not the gist' do
      expect(ordinary_link).to_not be_gist
    end
  end

  describe '#gist_parse' do
    it 'return last part of the gist url' do
      expect(gist_link.gist_parse).to eq('123')
    end
  end
end
