class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  #def index
   # @movies = Movie.all
  #end

  def index
      
      
       
       @all_ratings=Movie.uniq.pluck(:rating)

       
       @selected_ratings=params[:ratings].try(:keys)
       
       if @selected_ratings
         session[:selected_ratings_session]=@selected_ratings
         
         #@filered_movies=Movie.with_ratings(@selected_ratings)
         
       else
         
         @selected_ratings=session[:selected_ratings_session]
         
       end
         #@selected_ratings=@all_ratings
         
         #@sort_column = params[:sort_by]
         
        if params[:sort_by]
          @sort_column=params[:sort_by]
          session[:sort_column]= @sort_column
          
        else
          @sort_column=session[:sort_column]
          
        end
        
        @movies=@filered_movies
          
        @filered_movies=Movie.with_ratings(@selected_ratings).order(@sort_column)
        
        #@movies = Movie
        
       @movies=@filered_movies
          
  
       
       #@selected_ratings = (params["ratings"].present? ? params["ratings"] : @all_ratings)
       #@movies = @movies.where(":rating IN (?)", params["ratings"]) if params["ratings"].present? and params["ratings"].any?
   
       
       
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

end

