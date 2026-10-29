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
  end
end