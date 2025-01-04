class Cashflow < ApplicationRecord
  belongs_to :user
  validates :amount, presence: true
  validates :description, presence: true

  # Soft delete functionality
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  before_save :set_credit_debit
  before_save :assign_type_name_based_on_keyword

  private

  def set_credit_debit
    self.credit_debit = amount.negative? ? "credit" : "debit"
  end
  # Mark as deleted
  def soft_delete
    update(deleted_at: Time.current)
  end

  private

  def assign_type_name_based_on_keyword
    return unless description.present?

    matching_keyword = Keyword.find_by("LOWER(?) LIKE LOWER(CONCAT('%', name, '%'))", description)
    self.type_name = matching_keyword&.type_name
  end
  # Restore cashflow
  def restore
    update(deleted_at: nil)
  end
end
