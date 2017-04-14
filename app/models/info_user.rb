class InfoUser < ApplicationRecord
  belongs_to :user

  validates :introduce,
    length: {maximum: Settings.info_users.max_length_introduce}
  validates :ambition,
    length: {maximum: Settings.info_users.max_length_ambition}
  validates :quote,
    length: {maximum: Settings.info_users.max_length_quote}

  def age
    now = Time.now.utc.to_date
    now.year - birthday.year - (birthday.to_date.change(year: now.year) > now ? 1 : 0)
  end
end
