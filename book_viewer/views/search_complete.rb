
  def display_search_results(results, keyword)
    display = []    
    display << "<h2>Results for '#{keyword}'\n"
      
    results.each do |number, name|
      display << "<li><a href=\"chapters/#{number}\">#{name}</a></li>"
    end

    return "Sorry, no match for '#{keyword}'" if display.empty?
    display.join("\n")
  end