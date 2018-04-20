namespace :units do
  desc "add descriptions to zones and units"
  task description: :environment do

    def desc_prep(desc)
      desc = desc.inner_html
      # get rid of apostrophe character
      desc = desc.gsub("&#x2019;", "'")
      desc
    end

    path = "#{Rails.root}/lib/tasks/unit_descriptions.xml"
    desc_xml = File.open(path) { |f| Nokogiri::XML(f) }

    # zone descriptions
    desc_xml.xpath("//room").each do |room|
      zone_no = room["id"]
      zone = Zone.find_by(name: zone_no)
      if zone
        desc = room.xpath("desc")
        zone.update_attributes(description: desc_prep(desc))
      else
        puts "WARNING: No zone found for #{zone_no}"
      end
    end

    # unit descriptions
    desc_xml.xpath("//unit").each do |unit_xml|
      unit_no = unit_xml["id"]
      # check if leading zero needs to be removed
      if unit_no.length > 4 && unit_no[-2..-1] != "BW" && unit_no[0] == "0"
        unit_no = unit_no[1..-1]
      end
      unit = Unit.find_by(unit_no: unit_no)
      if unit
        desc = unit_xml.xpath("desc")
        unit.update_attributes(description: desc_prep(desc))
      else
        puts "WARNING: No unit found for #{unit_no}"
      end
    end
    
  end

end
