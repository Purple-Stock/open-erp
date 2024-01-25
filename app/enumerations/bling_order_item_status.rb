# frozen_string_literal: true

class BlingOrderItemStatus < EnumerateIt::Base
  associate_values(
    all: 99,
    in_progress: 15,
    checked: 101_065,
    verified: 24,
    pending: 94_871,
    printed: 95_745,
    canceled: 12,
    collected: 173_631
  )
end
