#!/usr/bin/env ruby
# supply a Magic Workstation deck URL from tcgplayer as cli arg
# e.g http://magic.tcgplayer.com/db/Deck_MWS.asp?ID=1230820&Name=Splinter%20Twin
require 'json'

decklist = ARGV[0]
deck_name = decklist.split('Name=')[1].gsub('%20','_')
temp_arry = `curl -s "#{decklist}"`.strip.split(/\r/)
File.open("#{deck_name}.dck", 'w') do |file|

  temp_arry.each do |card|
    number_of_cards = card.split(/(\d+)/)[1]
    name = card.split('] ')[1]
    converted_name = card.split('] ')[1].gsub(/ /, '+')
    card_data = JSON.parse(`curl -s https://api.deckbrew.com/mtg/cards?name=#{converted_name}`)
    set_info = "[#{card_data[0]['editions'][0]['set_id']}:#{card_data[0]['editions'][0]['number']}]"
    new_card = card.gsub(/\[.*\]/, "#{set_info}").strip
    file.puts new_card
  end
end
