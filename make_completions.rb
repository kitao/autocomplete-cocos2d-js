require 'open-uri'
require 'nokogiri'
require 'json'

BASE_URL = 'http://www.cocos2d-x.org/docs/api-ref/js/v3x/'
FILENAME = File.join(File.dirname(__FILE__), './completions.json')

URL_XPATH = '//li/a/@href'
COMMON_XPATH = '..//td[@class="nameDescription"]'
CLASS_XPATH = File.join('//caption[text()="Class Summary"]', COMMON_XPATH)
PROPERTY_XPATH = File.join('//caption[text()="Field Summary"]', COMMON_XPATH)
METHOD_XPATH = File.join('//h2[text()="Method Summary"]', COMMON_XPATH)
NAME_XPATH = './/div[@class="fixedFont"]/b/a/text()'

def parse_url
  puts "parse #{BASE_URL}"
  doc = Nokogiri::HTML(open(File.join(BASE_URL, 'index.html')))
  doc.xpath(URL_XPATH).map { |url| File.join(BASE_URL, url) }
end

def parse_name(doc, xpath)
  doc.xpath(xpath).map do |node|
    node.xpath(NAME_XPATH).to_s.strip.split('.').last
  end
end

def parse_page!(completions, url)
  puts "parse #{url}"
  doc = Nokogiri::HTML(open(url))
  completions[:class] += parse_name(doc, CLASS_XPATH)
  completions[:property] += parse_name(doc, PROPERTY_XPATH)
  completions[:method] += parse_name(doc, METHOD_XPATH)
  completions
end

def finish_completions!(completions)
  completions.each_value do |names|
    names.uniq!
    names.reject! { |name| !name || name.include?(' ') }
  end
  completions.each_value(&:sort!)
end

def save_completions(completions)
  puts "write #{FILENAME}"
  open(FILENAME, 'w') { |f| f.puts JSON.pretty_generate(completions) }
end

def make_completions
  completions = { class: [], property: [], method: [] }
  urls = parse_url
  urls.each { |url| parse_page!(completions, url) }
  finish_completions!(completions)
  save_completions(completions)
end

make_completions
