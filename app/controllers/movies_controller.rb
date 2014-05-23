class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    @movies = Movie.all
    @title = 'no'
    @date = 'no'
  	session[:p] = params[:p] if params[:p]
  	session[:ratings] = params[:ratings] if params[:ratings]
  	if session[:p]
  	  if session[:p] == 'title'
  	    @title = 'hilite'
  	    @movies = Movie.order :title
  	  else session[:p] == 'date'
  	    @date = 'hilite'
        @movies = Movie.order :release_date
      end
    end
          
    @all_ratings = Movie.select(:rating).uniq    
    if session[:ratings]
      @movies = @movies.select {|e| session[:ratings].include? e.rating}
      @ratings = session[:ratings]
    else
      @ratings = @all_ratings.collect {|e| e.rating}
    end
     
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def title_sort
    @movies = Movie.order :title
  end
  
  def date_sort
  	@movies = Movie.order :release_date
  end
  
end
