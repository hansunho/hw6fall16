class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
 class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)
    begin
    Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
    matching_movies = Tmdb::Movie.find(string)
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
  end
  
  def self.find_rating(movieID)
    movies = Tmdb::Movie.releases(movieID)['countries']
    if movies.nil? then return "N/A" end
    for i in 0..movies.size-1
      if (movies[i]["iso_3166_1"] == "US" && !movies[i]["certification"].blank?) then return movies[i]['certification']
      end  
    end
       "No MPAA raiting available"
  end
  
  
  def self.add_selected_movies(movies)
    for i in 0..movies.size-1
      tmdbMovie = Tmdb::Movie.detail(movies[i])
      movie = Movie.new()
      movie.title = tmdbMovie['title']
      movie.release_date = tmdbMovie['release_date']
      movie.rating = find_rating(movies[i])
      movie.description = tmdbMovie['overview']
      movie.save!
    end
  end
  
  
end