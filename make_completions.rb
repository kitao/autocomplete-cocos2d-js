require 'open-uri'
require 'nokogiri'
require 'json'

BASE_URL = 'http://www.cocos2d-x.org/reference/html5-js/V3.8/'
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

def parse_name(doc, xpath, type)
  doc.xpath(xpath).map do |node|
    name = node.xpath(NAME_XPATH).to_s.strip.split('.').last
    { text: name, type: type }
  end
end

def parse_page(url)
  puts "parse #{url}"
  doc = Nokogiri::HTML(open(url))
  completions = []
  completions += parse_name(doc, CLASS_XPATH, 'class')
  completions += parse_name(doc, PROPERTY_XPATH, 'property')
  completions += parse_name(doc, METHOD_XPATH, 'method')
  completions
end

def adjust_completions!(completions)
  completions.reject! do |e|
    text = e[:text]
    !text || text.include?(' ') || e[:type] == 'property' && text == 'create'
  end
  completions.push(text: 'view', type: 'property')
  completions.push(text: 'create', type: 'method')
  completions.uniq!
end

def save_completions(completions)
  puts "write #{FILENAME}"
  open(FILENAME, 'w') { |f| f.puts JSON.pretty_generate(completions) }
end

def make_completions
  completions = []
  urls = parse_url
  urls.each { |url| completions += parse_page(url) }
  adjust_completions!(completions)
  save_completions(completions)
end

make_completions
