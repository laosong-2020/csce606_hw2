class MoviesController < ApplicationController
  helper_method :sort_dir, :sort_column
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings_to_show = @all_ratings

    if params[:ratings] == nil
      @rating_list = @all_ratings
      @movies = Movie.all
    else
      @rating_list = params[:ratings].keys
      @movies = Movie.where({rating: @rating_list})
    end

    @movie_table = @movies.pluck()
    @rating_array = []
    @movie_table.each do |m_table|
      @rating_array << m_table[2]
    end
    @ratings_to_show = @rating_array.uniq
    if sort_dir != ""
      @movies = @movies.order("#{sort_column} #{sort_dir}").all
      if sort_column == "title"
        @MovieTitleClass = "hilite"
        @ReleaseDateClass = ""
      else
        @MovieTitleClass = ""
        @ReleaseDateClass = "hilite"
      end
    else
      @MovieTitleClass = ""
      @ReleaseDateClass = ""
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def sort_dir
    if params[:dir] == "asc"
      return "asc"
    elsif params[:dir] == "desc"
      return "desc"
    else
      return ""
    end
  end

  def sort_column
    if params[:column] == "Movie Title"
      return "title"
    elsif params[:column] == "Release Date"
      return "release_date"
    else
      return "title"
    end
  end
end
