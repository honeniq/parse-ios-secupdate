# -*- encoding: utf-8 -*-
require 'open-uri'
require 'nokogiri'
require 'csv'
require 'pry'

if ARGV.count == 0
  url = 'http://support.apple.com/ja-jp/HT6590'
else
  url = ARGV[0]
end

charset = nil
html = open(url) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)
m = url.match(%r{http://.*.apple.com/.*/(.+?)$})
output = m[1] + '.csv'  # match結果は配列の[1]に入る
csv = CSV.open(output, 'a:utf-8')

# Appleの脆弱性情報は1件ごとにtype=circleのulでまとめられている
doc.xpath('//ul[@type="circle"]/li').each do |li|
  buf = []
  li.xpath('p').each do | lip |
    buf.push(lip.text)
  end
  csv << buf
end

# BOM挿入(\uFEFF)
open(output, 'r+:utf-8') do |f|
  f.puts "\uFEFF#{open(output, 'r:utf-8').read}"
end
