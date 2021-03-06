module ViewHelper

  def active_link_to(name = nil, options = nil, html_options = nil, &block)
    html_options[:class] = "#{html_options[:class]} active" if current_page?(options)
    link_to(name, options, html_options, &block)
  end

  def active_class(link_path)
    'active' if current_page?(link_path)
  end

  def default_avatar_path(args)
    "/images/#{args}/default.png"
  end

end