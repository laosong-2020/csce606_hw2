class MoviesController < ApplicationController
  helper_method :sortingDirection, :sortingColumn
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #sortingColumn: "title " or "release_date"
    #sortingDirection: "asc" or "desc"
    if session[:column] == nil or (params[:column] != nil and session[:column] != sortingColumn)
      session[:column] = sortingColumn
    end
    if session[:dir] == nil or (params[:dir] != nil and session[:dir] != sortingDirection)
      session[:dir] = sortingDirection
    end
    
    if session[:ratings].blank? or params[:commit] != nil
      session[:ratings] = boxChecked
    end

    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @ratings_to_show = @all_ratings
    @checked_boxes = session[:ratings]

    if session[:dir] != ""
      if @checked_boxes.empty?
        @movies = Movie.order("#{session[:column]} #{session[:dir]}").all
      else
        @movies = Movie.order("#{session[:column]} #{session[:dir]}").select {|i| @checked_boxes.include?(i.rating)? true: false}
      end
      if session[:column] == "title"
        @MovieTitleClass = "hilite"
        @ReleaseDateClass = ""
      elsif session[:column] == "release_date"
        @MovieTitleClass = ""
        @ReleaseDateClass = "hilite"
      else
        @MovieTitleClass = ""
        @ReleaseDateClass = ""
      end
    else
      if @checked_boxes.empty?
        @movies = Movie.all
      else
        @movies = Movie.all.select{|i| @checked_boxes.include?(i.rating)? true: false}
      end
      @MovieTitleClass = ""
      @ReleaseDateClass = ""
    end
    @rating_array = []
    @movies.each do |m_table|
      @rating_array << m_table[:rating]
    end
    @movies = @movies.uniq
    @ratings_to_show = @rating_array.uniq
  
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

  def sortingDirection
    if params[:dir] == "asc"
      return "asc"
    elsif params[:dir] == "desc"
      return "desc"
    else
      return ""
    end
  end

  def sortingColumn
    if params[:column] == "Movie Title"
      return "title"
    elsif params[:column] == "Release Date"
      return "release_date"
    else
      return "title"
    end
  end

  private def boxChecked
    #read from params  to fill in cookies
    if params[:ratings] == nil
      return []
    end
    return params[:ratings]
  end
end
