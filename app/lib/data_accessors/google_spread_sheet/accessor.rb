require 'google_drive'
require_relative './attribute_info'

module DataAccessors
  module GoogleSpreadSheet
    class Accessor
      @@session = GoogleDrive::Session.from_config(File.join(File.dirname(__FILE__), "config.json"))
      @@db = @@session.spreadsheet_by_key("Write here your GoogleSpreadSheet key")

      def initialize(table_name)
        @ws = @@db.worksheet_by_title(table_name)
        @attribute_infos = _make_attribute_infos
      end

      def get_attribute_names
        @attribute_infos.map do |attr_info|
          attr_info.name
        end
      end

      # 新規作成
      # @param [Hash] attr_values アトリビュートの値
      # ex. {"id" => "123", "title" => "abc" ...}
      def create(attr_values)
        # 値をAttributeInfoに設定していく
        attr_values.each do |k, v|
          info = @attribute_infos.find do |info|
            info.name == k
          end
          info.value = v
        end

        row_num = @ws.num_rows + 1
        @attribute_infos.each do |info|
          @ws[row_num, info.col] = info.value
        end
        @ws.save
        @ws.reload
      end

      private
      def _make_attribute_infos
        (1..@ws.num_cols).map do |num_col|
          AttributeInfo.new(@ws[1, num_col], 1, num_col)
        end
      end
    end
  end
end
