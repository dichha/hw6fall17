require 'spec_helper'
require 'rails_helper'

describe MoviesController do
  describe 'searching TMDb' do
   it 'should call the model method that performs TMDb search' do
      fake_results = [double('movie1'), double('movie2')]
      expect(Movie).to receive(:find_in_tmdb).with('Ted').
        and_return(fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
    end
    it 'should select the Search Results template for rendering' do
      allow(Movie).to receive(:find_in_tmdb)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(response).to render_template('search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:tmdb_movies)).to eq(fake_results)
    end 
    it 'should give an error message when search term is empty' do
      post :search_tmdb, {:search_terms => ''}
      expect(response).to redirect_to(movies_path)
      expect(flash[:notice]).to be_present
    end
    
    describe "adding from TMDb" do
      it 'should call the model method that calls TMDb creation' do
        fake_results = []
        expect(Movie).to receive(:create_from_tmdb).with(100).and_return(fake_results)
        post :add_tmdb, {:tmdb_movies => ['100']}
      end
    end
  end
  
end
