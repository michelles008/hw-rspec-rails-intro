require 'rails_helper'
require 'spec_helper'

describe Movie do
  describe 'searching Tmdb by keyword' do
    it 'calls Faraday gem' do
      fake_response = double('response', body: '{"results":[]}')
      expect(Faraday).to receive(:get).and_return(fake_response)

      Movie.find_in_tmdb({title: "hacker", language: "en"})
    end

    it 'calls Tmdb with valid API key' do
      Movie.find_in_tmdb({title: "hacker", language: "en"})
    end

    it 'excludes movies already saved in RottenPotatoes' do
      Movie.create!(
        title: 'Sydney 2000 Olympics Opening Ceremony',
        rating: 'R',
        release_date: '2000-09-15'
      )

      results = Movie.find_in_tmdb(
        title: 'Olympics',
        release_year: '2000',
        language: 'en'
      )

      titles = results.map(&:title)

      expect(titles).not_to include('Sydney 2000 Olympics Opening Ceremony')
      expect(titles).to include('Sydney 2000 Olympics Closing Ceremony')
    end
  end
end