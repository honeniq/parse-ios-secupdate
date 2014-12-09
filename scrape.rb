# -*- encoding: utf-8 -*-
require 'open-uri'
require 'nokogiri'
require 'csv'
require 'pry'

url = 'http://support.apple.com/ja-jp/HT6441'

charset = nil
html = open(url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

doc = Nokogiri::HTML.parse(html, nil, charset)
output = "aaa.csv"

# Appleの脆弱性情報は1件ごとにulでまとめられている
doc.xpath('//ul[@type="circle"]/li').each do |li|
  buf = [] 
  li.xpath('p').each do | lip |
    buf.push(lip.text)
  end
  
  CSV.open(output,"ab") do |csv|
    csv << buf
  end
end

