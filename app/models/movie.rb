class Movie < ActiveRecord::Base
  class Movie:: InvalidKeyError < StandardError; end
  def self.all_ratings
    %w(G PG PG-13 NC-17 R NR)
  end
  
#class Movie::InvalidKeyError < StandardError ; end
  
#  def self.find_in_tmdb(string)
#    begin
#      Tmdb::Movie.find(string)
#    rescue Tmdb::InvalidApiKeyError
#        raise Movie::InvalidKeyError, 'Invalid API key'
#    end
#  end
  def self.create_from_tmdb(movie_id)
    tmdb_m = Tmdb::Movie.detail(movie_id)
    # new_movie_params = {}
    # movie_parameters = self.find_in_tmdb(new_m.title)
    # movie_parameters.each do |pairs|
    #   pairs.each do |key, val|
    #     if key == ":rating" 
    #       new_m.rating = val
    #     end
    #   end
    # end
    
    new_m = Movie.new
    new_m.title = tmdb_m["title"]
    new_m.description = tmdb_m["overview"]
    new_m.release_date = tmdb_m["release_date"]
    new_m.rating = self.find_ratings(movie_id)
    # movie_parameters = self.find_in_tmdb(new_m.title)
    # movie_parameters.each do |pairs|
    #   pairs.each do |key, val|
    #     if (key == ":rating") &&
    #       new_m.rating = val
    #     end
    #   end
    # end
  new_m.save
    
  end
  def self.find_ratings(movie_id)
    releases = Tmdb::Movie.releases(movie_id)
    rating = "NR"
    if !releases.nil?
      release_country = releases["countries"]
      if !release_country.nil? #|| !release_country.empty?
        release_country.each do |rate|
          if rate["iso_3166_1"] == "US"
            if !rate["certification"].empty? 
              rating = rate["certification"]
            end
          end
        end
      end
    end
    rating
  end

  def self.find_in_tmdb(keyword)
    matching_movies =[]
    begin
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      matching_movies = Tmdb::Movie.find(keyword)
    rescue Tmdb::InvalidApiKeyError
      raise Movie::InvalidKeyError, 'Invalid API key'
    end
   
    movies = []
    #matching_movies = Tmdb::Movie.find(keyword)
    if !matching_movies.nil? #|| !matching_movies.empty?
      matching_movies.each do |movie|
        rating = self.find_ratings(movie.id)
        # releases = Tmdb::Movie.releases(movie.id)
        # rating = "NR"
        # if !releases.nil?
        #   release_country = releases["countries"]
        #   if !release_country.nil? #|| !release_country.empty?
        #     release_country.each do |rate|
        #       if rate["iso_3166_1"] == "US"
        #         if !rate["certification"].empty? 
        #           rating = rate["certification"]
        #         end
        #       end
        #     end
        #   end
        # end
        #release_country_us_rating = releases["countries"][0]["certification"]
        movies.push({":id"=>"#{movie.id}",":title"=>"#{movie.title}",":rating"=>"#{rating}",":release_date"=>"#{movie.release_date}"})
      end
    end
    movies
  end
end
