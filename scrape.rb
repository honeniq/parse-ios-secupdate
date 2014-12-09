# -*- encoding: utf-8 -*-
require 'open-uri'
require 'nokogiri'
require 'csv'
require 'pry'

url = ARGV[0] 

charset = nil
html = open(url) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)
m = url.match(%r{http://.*.apple.com/.*/(.+?)$})
output = m[1] + '.csv'
csv = CSV.open(output,"ab:utf-8")


# Appleの脆弱性情報は1件ごとにtype=circleのulでまとめられている
doc.xpath('//ul[@type="circle"]/li').each do |li|
  buf = [] 
  li.xpath('p').each do | lip |
    buf.push(lip.text)
  end
  csv << buf
end
