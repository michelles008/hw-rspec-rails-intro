require 'rails_helper'

describe MoviesController, type: :controller do
  describe 'searching TMDb' do
    it 'calls the model method that performs TMDb search' do
      search_params = {
        title: 'hardware',
        release_year: '2000',
        language: 'en'
      }

      expect(Movie).to receive(:find_in_tmdb).with(search_params).and_return([])

      get :search_tmdb, params: search_params
    end

    it 'selects the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb).and_return([])

      get :search_tmdb, params: {
        title: 'hardware',
        language: 'en'
      }

      expect(response).to render_template('search_tmdb')
    end

    it 'makes the TMDb search results available to that template' do
      fake_movies = [double('movie1'), double('movie2')]
      allow(Movie).to receive(:find_in_tmdb).and_return(fake_movies)

      get :search_tmdb, params: {
        title: 'hardware',
        language: 'en'
      }

      expect(assigns(:movies)).to eq(fake_movies)
    end

     it 'shows an error when the movie title is blank' do
      expect(Movie).not_to receive(:find_in_tmdb)

      get :search_tmdb, params: {
        title: '',
        language: 'en'
      }

      expect(flash.now[:danger]).to eq(
        'Please fill in all required fields!'
      )
      expect(assigns(:movies)).to eq([])
    end

    it 'shows a warning when TMDb returns no movies' do
      allow(Movie).to receive(:find_in_tmdb).and_return([])

      get :search_tmdb, params: {
        title: 'nonexistencemovie123',
        language: 'en'
      }

      expect(flash.now[:warning]).to eq(
        'No movies found with given parameters!'
      )
      expect(assigns(:movies)).to eq([])
    end
  end

  describe 'adding a movie from TMDb' do
    it 'saves the selected movie to the database' do
      movie_params = {
        title: 'Manhunter',
        release_date: '1986-08-15',
        description: 'A crime thriller'
      }

      expect {
        post :add_movie, params: movie_params
      }.to change(Movie, :count).by(1)

      movie = Movie.last
      expect(movie.title).to eq('Manhunter')
      expect(movie.release_date.to_date.to_s).to eq('1986-08-15')
      expect(movie.rating).to eq('R')
      expect(response).to redirect_to(search_tmdb_path)
      expect(flash[:notice]).to eq(
        'Manhunter was successfully added to RottenPotatoes.'
      )
    end
  end
end