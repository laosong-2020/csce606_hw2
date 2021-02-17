module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  def sort_method(column)
    columnLowerCase = (column == "Movie Title")? "title":"release_date"
    dir = (columnLowerCase == sortingColumn && sortingDirection == "asc")? "desc":"asc"
    
    header = ""
    if columnLowerCase == "title"
      header = "title_header"
    else
      header = "release_date_header"
    end
    link_to "#{column.titleize}", {column: column, dir: dir}, :id => header
  end
end
