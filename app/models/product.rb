class Product < ApplicationRecord
  paginates_per ADMIN_ROW_PER_PAGE

  # 定数宣言
  include ConstantProduct
  include ValidateDatetime

  # 日付と時間を分割して設定する場合 true
  attr_accessor :is_divide_by_date_and_time
  # 日と時間を分けて取得
  attr_accessor :display_start_datetime_ymd, :display_start_datetime_hn
  attr_accessor :display_end_datetime_ymd, :display_end_datetime_hn
  # 画像削除用のID
  attr_accessor :delete_image

  before_validation :set_display_datetime
  belongs_to :category, optional: true
  belongs_to :tax_item
  has_one_attached :image

  enum status: { normal: 0, sales_suspension: 9 }, _prefix: true

  validates :name, uniqueness: true, presence: true, length: { minimum: MINIMUM_NAME, maximum: MAXIMUM_NAME }
  validates :manufacture_name, length: { maximum: MAXIMUM_MANUFACTURE_NAME }
  validates :code, length: { maximum: MAXIMUM_CODE }
  validates :sales_price, numericality: { greater_than_or_equal_to: 0,
                                          less_than_or_equal_to: MAXIMUM_SALES_PRICE },
                          allow_nil: true
  validates :regular_price, numericality: { greater_than_or_equal_to: 0,
                                            less_than_or_equal_to: MAXIMUM_REGULAR_PRICE },
                            allow_nil: true
  validates :number_of_stocks, numericality: { greater_than_or_equal_to: 0,
                                               less_than_or_equal_to: MAXIMUM_NUMBER_OF_STOCKS },
                               allow_nil: true
  validates :unlimited_stock, inclusion: { in: [true, false] }
  validates :display_start_datetime, datetime: true
  validates :display_end_datetime, datetime: true
  validates :description, length: { maximum: MAXIMUM_DESCRIPTION }
  validates :search_term, length: { maximum: MAXIMUM_SEARCH_TERM }
  validates :jan_code, length: { maximum: MAXIMUM_JAN_CODE }
  validates :status, presence: true

  # startよりendが小さい場合のバリデーション
  validate :validate_display_start_datetime_is_greater_than_end_datetime

  # display_start_datetime, display_end_datetimeそれぞれのymdとhnのバリデーション
  validate :validate_display_start_datetime_ymd_and_hn
  validate :validate_display_end_datetime_ymd_and_hn

  # display_start_datetime, display_end_datetimeをそれぞれymdとhnに代入
  after_save :set_display_start_datetime_ymd_and_hn
  after_save :set_display_end_datetime_ymd_and_hn
  after_find :set_display_start_datetime_ymd_and_hn
  after_find :set_display_end_datetime_ymd_and_hn
  # 画像を削除
  after_save :image_purge

  after_initialize do
    self.is_divide_by_date_and_time ||= false
  end

  def category_name
    category.name if category.present?
  end

  def tax_item_name
    tax_item.name if tax_item.present?
  end

  def unlimited_stock_name
    human_attribute_boolean(:unlimited_stock)
  end

  def status_name
    human_attribute_enum(:status)
  end

  private

  def image_purge
    image.purge if delete_image == '1'

    image.variant(resize: '100x100') if image.attached?
  end

  # is_divide_by_date_and_timeの値によって、日と時間を分割するか、日と時間を結合した値をセットする
  def set_display_datetime
    if is_divide_by_date_and_time
      self.display_start_datetime = combine_display_datetime(display_start_datetime_ymd, display_start_datetime_hn)
      self.display_end_datetime = combine_display_datetime(display_end_datetime_ymd, display_end_datetime_hn)
    else
      set_display_start_datetime_ymd_and_hn
      set_display_end_datetime_ymd_and_hn
    end
  end

  # 表示開始日時から表示開始日と表示開始時間を取得する
  def set_display_start_datetime_ymd_and_hn
    @display_start_datetime_ymd = display_start_datetime.to_s.present? ? display_start_datetime.to_s.split(' ').first : nil
    @display_start_datetime_hn = display_start_datetime.to_s.present? ? display_start_datetime.to_s.split(' ').second : nil
  end

  # 表示終了日時から表示終了日と表示終了時間を取得する
  def set_display_end_datetime_ymd_and_hn
    @display_end_datetime_ymd = display_end_datetime.to_s.present? ? display_end_datetime.to_s.split(' ').first : nil
    @display_end_datetime_hn = display_end_datetime.to_s.present? ? display_end_datetime.to_s.split(' ').second : nil
  end

  # 表示終了日時より表示開始日時が大きいかのバリデーション
  def validate_display_start_datetime_is_greater_than_end_datetime
    validate_start_datetime_is_greater_than_end_datetime display_start_datetime, display_end_datetime,
                                                         Product.human_attribute_name(:display_start_datetime),
                                                         :display_end_datetime
  end

  # 表示開始日と表示開始時間のバリデーション
  def validate_display_start_datetime_ymd_and_hn
    validate_datetime_ymd_and_hn(display_start_datetime_ymd, display_start_datetime_hn,
                                 :display_start_datetime_ymd, :display_start_datetime_hn)
  end

  # 表示終了日と表示終了時間のバリデーション
  def validate_display_end_datetime_ymd_and_hn
    validate_datetime_ymd_and_hn(display_end_datetime_ymd, display_end_datetime_hn,
                                 :display_end_datetime_ymd, :display_end_datetime_hn)
  end
end
