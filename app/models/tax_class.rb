class TaxClass < ApplicationRecord
  has_many :tax_items, dependent: :restrict_with_error

  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 40 }

  validates :tax_rate, presence: true
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0,
                                       less_than_or_equal_to: 1 }

  private

  def validate_exists_as_a_parent
    parent = TaxItem.find(search_parent_id)


      return if parent.nil? || parent.parent_id.nil?

      if parent.parent_id == id
        errors.add(:parent_id, I18n.t('errors.messages.exists_as_a_parent',
                                      parent: Category.human_attribute_name(:parent_name)))
        return
      end

      search_parent_id = parent.parent_id
    end

    errors.add(:parent_id, I18n.t('errors.messages.exists_as_a_parent',
                                  parent: Category.human_attribute_name(:parent_name)))
end
end
