module DataAccessors
  module GoogleSpreadSheet
    class AttributeInfo
      attr_reader :name, :row, :col
      attr_accessor :value

      def initialize(name, row, col, value=nil)
        @name = name
        @row = row
        @col = col
        @value = value
      end
    end
  end
end
