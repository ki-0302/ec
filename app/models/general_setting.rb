class GeneralSetting < ApplicationRecord
  include Region

  # 最小桁数
  MINIMUM_SITE_NAME = 2
  # 最大桁数
  MAXIMUM_SITE_NAME = 40
  MAXIMUM_REGION = 40
  MAXIMUM_ADDRESS1 = 40
  MAXIMUM_ADDRESS2 = 40
  MAXIMUM_ADDRESS3 = 40

  validates :site_name, presence: true, length: { minimum: MINIMUM_SITE_NAME, maximum: MAXIMUM_SITE_NAME }
  validates :address1, length: { maximum: MAXIMUM_ADDRESS1 }
  validates :address2, length: { maximum: MAXIMUM_ADDRESS2 }
  validates :address3, length: { maximum: MAXIMUM_ADDRESS3 }
  validates :phone_number, allow_blank: true,
                           format: { with: /\A(0(5|7|8|9)0-?\d{4}-?\d{4}|0\d{1}-?-\d{4}-?\d{4}|0\d{2}-?-\d{3}-?\d{4}|0\d{3}-?-\d{2}-?\d{4}|0\d{4}-?-\d{1}-?\d{4})\z/ }
  validate :validate_region

  private

  def validate_region
    return if region.blank?

    errors.add(:region, I18n.t('errors.messages.invalid')) unless region_hash.value?(region)
  end
end
