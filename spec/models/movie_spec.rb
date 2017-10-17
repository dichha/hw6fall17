require 'spec_helper'
require 'rails_helper'

describe Movie do
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords' do
        expect(Tmdb::Movie).to receive(:find).with('Inception')
        Movie.find_in_tmdb('Inception')
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  describe 'new movie made from Tmdb' do
    before do
      @new_movie = Movie.new(:id => 12, :title => "Inception", :rating =>'G',:description => "Such a cool movie", :release_date => '2015-12-12', :created_at => '2017-10-10-06:00', :updated_at => '2017-10-10-12:00')
    end
    it "can be saved" do
      expect(@new_movie).to respond_to(:save)
      expect(@new_movie.save).to be true
    end 
  end
end
