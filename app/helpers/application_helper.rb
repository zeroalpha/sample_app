module ApplicationHelper
  def title
    base_title = "Ruby on Rails Tutorial Sample App"
    
    if @title.nil? || @title.empty?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  def logo
    
  end
end
