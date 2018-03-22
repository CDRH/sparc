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
    File.open(path, "w") { |file| file.write(map) }
    puts "Finished, please refresh your browser"
  end

end
