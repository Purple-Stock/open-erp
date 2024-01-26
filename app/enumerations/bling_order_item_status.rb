# frozen_string_literal: true

# Check the doc at https://github.com/lucascaton/enumerate_it#using-enumerations
class BlingOrderItemStatus < EnumerateIt::Base
  associate_values(
    all: '99',
    in_progress: '15',
    checked: '101065',
    verified: '24',
    pending: '94871',
    printed: '95745',
    canceled: '12',
    collected: '173631'
  )
end
