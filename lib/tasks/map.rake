namespace :maps do
  desc "add links to SVG, ONLY RUN ONCE"
  task links: :environment do

    path = "#{Rails.root}/app/views/explore/_svg.html.erb"
    map = File.read(path)
    puts "Altering map file"

    # links for san juan and trenches
    map.gsub!(/a xlink:href="(.*)"/, "a href=\"zone/\\1\"")
    # links for TEXT ONLY of chaco (not sure how to link text and polygon)
    map.gsub!(/(<g clip-path.*>\n *<text transform.*>(.*)<\/text>\n *<\/g>)/,
      "<a href=\"zone/\\2\">\\1</a>"
    )
    # fix unit names for trenches, plazas, backwalls
    map.gsub!(/(\d*)-(P|BW|TT)/, "\\1\\2")
    map.gsub!(/(\d)-(\d*)-?(P)/, "\\1\\2\\3")
    map.gsub!(/href="zone\/(\d*)[ABC](?!W)/, "href=\"zone/\\1")

    File.open(path, "w") { |file| file.write(map) }
    puts "Finished, please refresh your browser"
    puts <<-TEXT
      Please copy the lines <g id=\"chaco_occ\" display=\"none\">
      through the closing tag and add ?occupation=chaco to the links
      (find href=\"(.*)\", replace href=\"\1?occupation=chaco\")
      TEXT
  end

end
