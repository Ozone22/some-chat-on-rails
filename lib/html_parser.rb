class HtmlParser

  USER_AGENT = 'firefox'
  CHARSET = 'UTF-8'

  def self.parse(parse_url)
    page = Nokogiri::HTML(open(parse_url, 'User-Agent' => USER_AGENT), nil, CHARSET)

    data = meta_parse(page.xpath("//head//meta"))

    data[:url] = parse_url if data[:url].empty?
    data[:image_url] =  parse_url if data[:image_url].empty?

    data
  end

  private

  def self.meta_parse(head_meta)

    data = { title: '', description: '', url: '', image_url: '' }

    head_meta.each do |meta|
      if meta['name'] == 'description'
        data[:description] = meta['content']
      else
        case meta['property']
          when 'og:title'
            data[:title] = meta['content']
          when 'og:description'
            data[:description] = meta['content']
          when 'og:url'
            data[:url] = meta['content']
          when 'og:image'
            data[:image_url] = meta['content']
          else
            # type code here
        end
      end
    end

    data
  end

end