class MoviesController < ApplicationController
    helper_method :chosen_rating?

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R']
   
      if (params[:ratings].nil? && !session[:ratings].nil?) || (params[:order].nil? && !session[:order].nil?)
          redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
      elsif !params[:ratings].nil? || !params[:order].nil?
          if !params[:ratings].nil?
            array_ratings = params[:ratings].keys
            return @movies = Movie.where(rating: array_ratings).order(session[:order])
          else
            return @movies = Movie.all.order(session[:order])
          end
     elsif !session[:ratings].nil? || !session[:order].nil?
       redirect_to movies_path("ratings" => session[:ratings], "order" => session[:order])
     else
       return @movies = Movie.all
     end
    if params[:sort] == "title"
        @movies = Movie.order('title')
    elsif params[:sort] == "release_date"
        @movies = Movie.order('release_date')
    elsif params[:ratings].nil?
        @movies = Movie.all
    else
   @movies = Movie.where(rating: array_ratings)
    end
      
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
    
  def chosen_rating?(rating)
    chosen_ratings = session[:ratings]
    return true if chosen_ratings.nil?
    chosen_ratings.include? rating
  end

end
