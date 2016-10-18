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
      post :search_tmdb, {:search_terms => 'Ted'}

      allow(Movie).to receive(:find_in_tmdb)
           expect(response).to render_template('movies/search_tmdb')
    end  
    it 'should make the TMDb search results available to that template' do
      fake_results = [double('Movie'), double('Movie')]
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)
      post :search_tmdb, {:search_terms => 'Ted'}
      expect(assigns(:movies)).to eq(fake_results)
    end 
    
    
    it 'should return to movies page if no matches were found' do
      post :search_tmdb, {:search_terms => ';'}
      allow(Movie).to receive(:find_in_tmdb).and_return (fake_results)

      expect(flash[:notice]).to eq("No matching movies were found on TMDb.")
    end
    
    it 'sould show flash notice "No Movies Selected" if try to add movies without any checked ' do 
      post :add_tmdb, {:tmdb_movies => []}
      expect(response).to redirect_to('/movies')
      expect(flash[:notice]).to eq("No movies selected")
    end
    

    it 'should show flash notice if invalid search term is used' do
      post :search_tmdb, {:search_terms => ''}
      expect(response).to redirect_to('/movies')
      expect(flash[:notice]).to eq("Invalid search term")
    end
  end
end
