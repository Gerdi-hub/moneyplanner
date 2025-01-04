class Cashflow < ApplicationRecord
  belongs_to :user
  validates :amount, presence: true
  validates :description, presence: true

  # Soft delete functionality
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  before_save :set_credit_debit

  private

  def set_credit_debit
    self.credit_debit = amount.negative? ? "credit" : "debit"
  end
  # Mark as deleted
  def soft_delete
    update(deleted_at: Time.current)
  end

  # Restore cashflow
  def restore
    update(deleted_at: nil)
  end
end
