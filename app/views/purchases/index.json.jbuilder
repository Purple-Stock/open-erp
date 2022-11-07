# frozen_string_literal: true

json.array! @purchases, partial: 'purchases/purchase', as: :purchase
