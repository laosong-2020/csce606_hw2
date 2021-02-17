module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def sort_method(column)
    column2 = (column == "Movie Title")? "title":"release_date"
    dir = (column2 == sort_column && sort_dir == "asc")? "desc":"asc"
    
    header = ""
    if column2 == "title"
      header = "title_header"
    else
      header = "release_date_header"
    end
    link_to "#{column.titleize}", {column: column, dir: dir}, :id => header
  end
end
