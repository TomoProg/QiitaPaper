require_relative './base_model'

module Models
  class Article < BaseModel
    module NotifyStatus
      NOT_NOTIFY = 0
      FIN = 1
    end
  end
end