require 'nokogiri'
require 'httparty'
require 'byebug'
require 'spreadsheet'

def scraper
  url = "https://roomfi.ru/kovorkingi/"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  kovorkings = Array.new()

  #пагинация
  kovorking_listings = parsed_page.css("div.obj-card") #15 объектов на странице

  last_page = parsed_page.css("ul.pagination > li").count-1.to_i #-1 - минус кнопка "далее"
  page = 1.to_i
  while page <= last_page #пагинация
    pagination_url = "https://roomfi.ru/kovorkingi/?page=#{page}"
    pagination_unparsed_page = HTTParty.get(pagination_url)
    pagination_parsed_page = Nokogiri::HTML(pagination_unparsed_page)
    pagintaion_kovorking_listings = pagination_parsed_page.css("div.obj-card")
      pagintaion_kovorking_listings.each do |kovorking_listing|
      count = 0
      kovorking = {
        name: parsed_page.css("p.obj-title")[count].text.to_s,
        prefix:parsed_page.css("div.obj-info > p.obj-prefix").text,
        url: "https://roomfi.ru" + kovorking_listings.css('a')[count].attributes["href"].value.to_s,
        img_url: "https://roomfi.ru" + kovorking_listings.css('img')[count].attributes["src"].value.to_s,
        time: parsed_page.css("div.obj-price.form-group-margin")[count].text.to_s
      }
      kovorkings << kovorking
      count += 1
      end
    page += 1
  end
  byebug
 #таблица
  table = Spreadsheet::Workbook.new
  sheet1 = table.create_worksheet
  sheet1.row(0).concat %w{Name Prefix Url ImgUrl Time}
  # запись name'ов
  i = 0
  while i < kovorkings.size do
  sheet1.row(i+1).push kovorkings[i][:name]
  i += 1

  table.write 'C:\Users\v\Desktop\scraper\demo.xls'
  end

  #запись титлов
  i = 0
  while i < kovorkings.size do
  sheet1.row(i+2).push kovorkings[i][:prefix]
  i += 1

  table.write 'C:\Users\v\Desktop\scraper\demo.xls'
  end

  #запись url
  i = 0
  while i < kovorkings.size do
  sheet1.row(i+3).push kovorkings[i][:url]

  table.write 'C:\Users\v\Desktop\scraper\demo.xls'
  end

  #запись img url
  i = 0
  while i < kovorkings.size do
  sheet1.row(i+4).push kovorkings[i][:img_url]

  table.write 'C:\Users\v\Desktop\scraper\demo.xls'
  end

  #часы работы
  i = 0
  while i < kovorkings.size do
  sheet1.row(i+5).push kovorkings[i][:time]

  table.write 'C:\Users\v\Desktop\scraper\demo.xls'
  end
end
scraper





