module <%= human_name %>Helper
  
  # Adding flash div here.
  # NOTE: This should be removed if using scaffy on multiple models.
  # Returns a div for each key passed if there's a flash
  # with that key
  def flash_div *keys
    divs = keys.select { |k| flash[k] }.collect do |k|
      content_tag :div, flash[k], :class => "flash #{k}"
    end
    divs.join
  end
  
end
