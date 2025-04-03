class TaMapping < ApplicationRecord
  belongs_to :course
  belongs_to :ta, class_name: 'User', foreign_key: 'user_id'

  #Returns course ids of the TA
  def self.get_course_ids(user_id)
    TaMapping.find_by(user_id: user_id).course_id
  end

  #Returns courses of the TA
  def self.get_courses(user_id)
    Course.where('id = ?', get_course_ids(user_id))
  end
end
