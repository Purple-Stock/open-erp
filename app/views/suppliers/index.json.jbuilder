# frozen_string_literal: true

json.array! @suppliers, partial: 'suppliers/supplier', as: :supplier
