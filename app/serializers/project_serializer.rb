class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :start_date, :finish_date
end
