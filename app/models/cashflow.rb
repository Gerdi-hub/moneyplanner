class Cashflow < ApplicationRecord
  belongs_to :user
  validates :amount, presence: true, numericality: { other_than: 0 }
  validates :description, presence: true, length: { maximum: 200 }
  validates :type_name, length: { maximum: 50 }
  validates :date, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }
  monetize :amount, as: :money_amount, numericality: true

  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end

  private

  before_save :set_credit_debit
  before_save :assign_type_name_based_on_keyword

  def set_credit_debit
    self.credit_debit = amount.negative? ? "credit" : "debit"
  end

  def assign_type_name_based_on_keyword
    return if type_name.present?
    return unless description.present?

    matching_keyword = Keyword.find_by("LOWER(?) LIKE LOWER(CONCAT('%', name, '%'))", description)
    self.type_name = matching_keyword&.type_name
  end
end
