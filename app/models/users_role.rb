# Pretty much exclusively created for our fixtures to work
class UsersRole < ApplicationRecord
  belongs_to :user
  belongs_to :role
end
