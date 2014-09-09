module ApplicationHelper

   # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "HIE Data Pages"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  
  def full_heading(first_name, surname)
    if first_name.nil? && surname.nil?
      'Home Page'
    else
      "Home Page for"+" " + first_name + " " + surname
    end
  end
  
  def show_minibar?(current_path)
    if [root_path, about_path, contact_path, help_path, users_path, register_path, sessions_path, signin_path].include? current_path  
      return false
    elsif current_path.include? "/data-management"
      return false
    else
      return true
    end     
  end
  
  def markdown(text)
    options = {
      filter_html:     false,
      hard_wrap:       true, 
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true, 
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

end