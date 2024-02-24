# frozen_string_literal: true

# Check the doc at https://github.com/lucascaton/enumerate_it#using-enumerations
class FeatureKey < EnumerateIt::Base
  associate_values(
    stock: 0,
    bling_integration: 1
  )
end
