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

def paragraphs_matching(chapter, query)
  results = {}
  
  chapter.split("\n\n").each_with_index do |paragraph, p_id|
    results[p_id] = paragraph if paragraph.include?(query)
  end

  results
end


=begin
- iterate through @ results -> {name: name (used for displaying), number: number (used for links), paragraphs: { p_id => paragraph}}
- 
=end
def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    if contents.include?(query)      
      results.push({name: name, number: number, paragraphs: paragraphs_matching(contents, query) })
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
    text.split("\n\n").map.with_index do |paragraph, idx|
      "<p id=\"paragraph_#{idx}\">#{paragraph}</p>"
    end.join    
  end

  def highlight_results(paragraph, query)
    paragraph.gsub(query, "<strong>#{query}</strong>")
  end
end

