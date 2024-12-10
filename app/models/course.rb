# frozen_string_literal: true

class Course < ApplicationRecord
  validates :title, :description, :begins_at, presence: true
end

# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  begins_at   :datetime         not null
#  description :text             default(""), not null
#  ends_at     :datetime
#  title       :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
