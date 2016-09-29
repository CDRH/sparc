module ActiveScaffold
  module DataStructures
    class Column
      # @new_by_search = true
      attr_writer :new_by_search
      def new_by_search
        if @new_by_search != nil
          @new_by_search
        else
          true
        end
      end
    end
  end
end