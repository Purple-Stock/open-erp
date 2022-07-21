class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include ChronologicalOrder
  include SpreadsheetArchitect

  # Adjust default sort order
  self.implicit_order_column = :created_at
end
