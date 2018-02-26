# frozen_string_literal: true

module Todoable
  module Utils
    def stringify_keys(target_hash)
      target_hash.each_with_object({}) do |(key, value), hash|
        value = value.stringify_keys if value.is_a?(Hash)
        hash[key.to_s] = value
      end
    end
  end
end
