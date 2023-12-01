#
# FactoryBot.define do


#   factory :user do
#     sequence(:name) { |_n| Faker::Name.unique.name.to_s.delete(" \t\r\n").downcase }
#     sequence(:email) { |_n| Faker::Internet.email.to_s }
#     password { 'password' }
#     sequence(:full_name) { |_n| "#{Faker::Name.name}#{Faker::Name.name}".downcase }
#     role factory: :role
#     institution factory: :institution
#   end
#
#   factory :role do
#     name { Faker::Name.name }
#   end
#
#   factory :assignment do
#     name { (Assignment.last ? "assignment#{Assignment.last.id + 1}" : 'final2').to_s }
#     instructor { Instructor.first || association(:instructor) }
#   end
#
#   factory :invitation do
#     from_user factory: :user
#     to_user factory: :user
#     assignment factory: :assignment
#     reply_status { 'W' }
#   end
#
#   factory :institution, class: Institution do
#     name {'North Carolina State University'}
#   end
#
#   if ActiveRecord::Base.connection.table_exists?(:roles)
#     factory :role_of_instructor, class: Role do
#       name { 'Instructor' }
#       parent_id { nil }
#     end
#   end
#
#   factory :instructor, class: Instructor do
#     name {'instructor6'.downcase}
#     role {Role.where(name: 'Instructor').first || association(:role_of_instructor)}
#     full_name {'6, instructor'}
#     password {"sample_password"}
#     parent_id {1}
#     email {'instructor6@gmail.com'}
#     before(:create) { |instructor| instructor.name = instructor.name.downcase }
#   end
#
#   factory :course, class: Course do
#     sequence(:name) { |n| "CSC517, test#{n}" }
#     instructor { Instructor.first || association(:instructor) }
#     directory_path {'csc517/test'}
#     info {'Object-Oriented Languages and Systems'}
#     private {true}
#     institution { Institution.first || association(:institution) }
#   end
# end
