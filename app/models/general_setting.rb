class GeneralSetting < ApplicationRecord
  require 'nkf'

  # 最小桁数
  MINIMUM_SITE_NAME = 2
  # 最大桁数
  MAXIMUM_SITE_NAME = 40
  MAXIMUM_REGION = 40
  MAXIMUM_ADDRESS1 = 40
  MAXIMUM_ADDRESS2 = 40
  MAXIMUM_ADDRESS3 = 40

  # 日付と時間を分割して設定する場合 true
  attr_accessor :is_divide_by_postal_code

  before_validation :before_validation_postal_code
  before_validation :before_validation_phone_number

  validates :site_name, presence: true, length: { minimum: MINIMUM_SITE_NAME, maximum: MAXIMUM_SITE_NAME }
  validates :postal_code, allow_blank: true,
                          format: { with: /\A\d{3}-?\d{4}\z/ }
  validates :address1, length: { maximum: MAXIMUM_ADDRESS1 }
  validates :address2, length: { maximum: MAXIMUM_ADDRESS2 }
  validates :address3, length: { maximum: MAXIMUM_ADDRESS3 }
  validates :phone_number, allow_blank: true,
                           format: { with: /\A(0(5|7|8|9)0-?\d{4}-?\d{4}|0\d{1}-?-\d{4}-?\d{4}|0\d{2}-?-\d{3}-?\d{4}|0\d{3}-?-\d{2}-?\d{4}|0\d{4}-?-\d{1}-?\d{4})\z/ }
  validate :validate_region

  private

  def before_validation_postal_code
    return if postal_code.blank?

    # 全角を半角にする
    self.postal_code = NKF.nkf('-m0Z1 -W -w', postal_code)
    self.postal_code = postal_code.delete(' ')
    self.postal_code = postal_code.delete('-')
  end

  def before_validation_phone_number
    return if phone_number.blank?

    # 全角を半角にする
    self.phone_number = NKF.nkf('-m0Z1 -W -w', phone_number)
    self.phone_number = phone_number.delete(' ')
  end

  def validate_region
    return if region.blank?

    errors.add(:region, I18n.t('errors.messages.invalid')) unless Common::Region.hash.value?(region)
  end
end
