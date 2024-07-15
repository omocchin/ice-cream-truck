class Setting < ApplicationRecord
  belongs_to :store_location

  # Convert tax string to percentage
  def tax_to_percent
    BigDecimal(self.tax_percentage) / 100
  end
end
