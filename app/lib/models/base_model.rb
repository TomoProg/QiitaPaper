require_relative '../extensions/extension_loader'
require_relative '../data_accessors/google_spread_sheet/accessor'

module Models
  class BaseModel
    class << self
      def table_name
        self.to_s.split('::').last.to_snake_case
      end
    end

    def initialize
      define_attribute
    end

    # データアクセサクラス取得
    # @return [DataAccessor]
    def data_accessor
      @data_accessor ||= DataAccessors::GoogleSpreadSheet::Accessor.new(self.class.table_name)
    end

    # アトリビュート定義
    def define_attribute
      data_accessor.get_attribute_names.each do |attr|
        self.class.attr_accessor attr
      end
    end

    def create
      values = data_accessor.get_attribute_names.inject({}) do |result, name|
        result[name] = send("#{name}"); result
      end
      data_accessor.create(values)
    end
  end
end
