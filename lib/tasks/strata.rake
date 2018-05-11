namespace :strata do
  desc "Associates strat type and strat groupings"
  task groupings: :environment do
    StratType.all.each do |type|
      code = type[:code]
      case code
      when "E", "F", "FC", "N"
        group_name = "Roof"
      when "C", "CT", "CU", "M"
        group_name = "Midden"
      when "H", "I", "O"
        group_name = "Floor"
      when "L"
        group_name = "Features"
      when "G"
        group_name = "Occupational Fill"
      else
        group_name = "Other"
      end
      puts "strat type code: #{code} group_name: #{group_name}"
      grouping = StratGrouping.find_by(name: group_name)
      type.update_attributes(strat_grouping: grouping)
    end
  end
end
