class Cashflow < ApplicationRecord
  belongs_to :user
  validates :amount, presence: true
  validates :description, presence: true

  # Soft delete functionality
  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  # Mark as deleted
  def soft_delete
    update(deleted_at: Time.current)
  end

  # Restore cashflow
  def restore
    update(deleted_at: nil)
  end
end
