class Movie < ActiveRecord::Base
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end

  def self.find_in_tmdb(search_params)
    url = 'https://api.themoviedb.org/3/search/movie'

    query = {
      api_key: ENV['TMDB_API_KEY'],
      query: search_params[:title],
      language: search_params[:language]
    }

    query[:year] = search_params[:release_year] if search_params[:release_year].present?

    response = Faraday.get(url, query)
    results = JSON.parse(response.body).fetch('results', [])

    results = results.reject do |movie_data|
      Movie.exists?(title: movie_data['title'])
    end

    results.map do |movie_data|
      Movie.new(
        title: movie_data['title'],
        release_date: movie_data['release_date'],
        description: movie_data['overview'],
        rating: 'R'
      )
    end
  end
end
