require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

def each_chapter
  @contents.each_with_index do |name, idx|
    number = idx + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    if contents.include?(query)
      results.push({name: name, number: number })
    end    
  end

  results
end

before do
  @contents = File.readlines "data/toc.txt"
end

get "/" do
  @title = "The Adventures of Sherlock Holmes" 

  erb :home
end

get "/chapters/:number" do  
  number = params[:number].to_i
  chapter_title = @contents[number - 1]

  redirect "/" unless (1..@contents.size).cover?(number)

  @title = "Chapter #{number}: #{chapter_title}"  
  @chapter = File.read "data/chp#{number}.txt"

  erb :chapter
end

get "/search" do  
  @results = chapters_matching(params[:query])
  erb :search  
end 

not_found do
  redirect "/"
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join    
  end

  def display_search_results(results, keyword)
    return "<h4>Type in a keyword</h4>" if keyword.nil?
    return "<h4>Sorry, no match for '#{keyword}'</h4>" if results.empty?

    display = []    
    display << "<h4>Results for '#{keyword}'\n</h4>"
      
    results.each do |number, name|
      display << "<li><a href=\"chapters/#{number}\">#{name}</a></li>"
    end
    
    display.join("\n")
  end
end

