# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def format_title(title)
    title_words = title.split(" ")
    
    if title_words.size >= 2
      f_half_loc = (title_words.size/2.0).ceil
      content = "<span class='first_half'>"
      (0..f_half_loc-1).each do |i|
        content += title_words[i]
      end
      content += "</span>"
      
      content += "<span class='second_half'>"
      (f_half_loc..title_words.size-1).each do |i|
        content += title_words[i]
      end
      content += "</span>"
      
    else
      content = title
    end
    return content
  end

end
