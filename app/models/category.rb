class Category < ApplicationRecord
  paginates_per ROW_PER_PAGE

  # 日付と時間を分割して設定する場合 true
  attr_accessor :is_divide_by_date_and_time

  after_initialize do
    self.is_divide_by_date_and_time ||= false
  end

  attr_accessor :display_start_datetime_ymd, :display_start_datetime_hn
  attr_accessor :display_end_datetime_ymd, :display_end_datetime_hn

  before_validation :set_display_datetime
  before_validation :validate_parrent_id_assigned_by_self
  before_validation :validate_exists_as_a_parent

  has_many :category_id, class_name: 'Category', foreign_key: 'parent_id', dependent: :nullify
  belongs_to :parent, class_name: 'Category', optional: true

  validates :parent_id, numericality: true, allow_nil: true
  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 40 }
  validates :display_start_datetime, datetime: true
  validates :display_end_datetime, datetime: true

  # startよりendが小さい場合のバリデーション
  validate :validate_start_datetime_is_greater_than_end_datetime

  # display_start_datetime, display_end_datetimeそれぞれのymdとhnのバリデーション
  validate :validate_display_start_datetime_ymd_and_hn
  validate :validate_display_end_datetime_ymd_and_hn

  # display_start_datetime, display_end_datetimeをそれぞれymdとhnに代入
  after_save :set_display_start_datetime_ymd_and_hn
  after_save :set_display_end_datetime_ymd_and_hn
  after_find :set_display_start_datetime_ymd_and_hn
  after_find :set_display_end_datetime_ymd_and_hn

  def parrent_name
    parent.name
  end

  private

  def set_display_datetime
    if is_divide_by_date_and_time
      self.display_start_datetime = combine_display_datetime(display_start_datetime_ymd, display_start_datetime_hn)
      self.display_end_datetime = combine_display_datetime(display_end_datetime_ymd, display_end_datetime_hn)
    else
      set_display_start_datetime_ymd_and_hn
      set_display_end_datetime_ymd_and_hn
    end
  end

  def combine_display_datetime(date, time)
    if date.blank? || time.blank?
      nil
    else
      begin
        Time.zone.parse([date, time].join(' '))
      rescue StandardError
        nil
      end
    end
  end

  def set_display_start_datetime_ymd_and_hn
    @display_start_datetime_ymd = display_start_datetime.to_s.present? ? display_start_datetime.to_s.split(' ').first : nil
    @display_start_datetime_hn = display_start_datetime.to_s.present? ? display_start_datetime.to_s.split(' ').second : nil
  end

  def set_display_end_datetime_ymd_and_hn
    @display_end_datetime_ymd = display_end_datetime.to_s.present? ? display_end_datetime.to_s.split(' ').first : nil
    @display_end_datetime_hn = display_end_datetime.to_s.present? ? display_end_datetime.to_s.split(' ').second : nil
  end

  def validate_start_datetime_is_greater_than_end_datetime
    return if display_start_datetime.nil? || display_end_datetime.nil?

    return if display_start_datetime <= display_end_datetime

    caption_display_start_datetime = Category.human_attribute_name(:display_start_datetime)
    errors.add(:display_end_datetime, I18n.t('errors.messages.greater_than', count: caption_display_start_datetime))
  end

  def validate_display_start_datetime_ymd_and_hn
    return if display_start_datetime_ymd.blank? && display_start_datetime_hn.blank?

    if !Common::Validation.date(display_start_datetime_ymd)
      errors.add(:display_start_datetime_ymd, I18n.t('errors.messages.not_a_date'))
    elsif !Common::Validation.time(display_start_datetime_hn)
      errors.add(:display_start_datetime_hn, I18n.t('errors.messages.not_a_time'))
    end
  end

  def validate_display_end_datetime_ymd_and_hn
    return if display_end_datetime_ymd.blank? && display_end_datetime_hn.blank?

    if !Common::Validation.date(display_end_datetime_ymd)
      errors.add(:display_end_datetime_ymd, I18n.t('errors.messages.not_a_date'))
    elsif !Common::Validation.time(display_end_datetime_hn)
      errors.add(:display_end_datetime_hn, I18n.t('errors.messages.not_a_time'))
    end
  end

  # 親IDに自身が割り当てらていないか
  def validate_parrent_id_assigned_by_self
    return if id.nil? || parent_id.nil? || id != parent_id

    errors.add(:parent_id, I18n.t('errors.messages.assigned_by_self'))
  end

  # 自分より上位の親カテゴリーに自身が含まれていないかチェック。無限ループになるため
  def validate_exists_as_a_parent
    return if id.nil? || parent_id.nil?

    search_parent_id = parent_id

    10.times do
      parent = Category.find_by(id: search_parent_id)
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
