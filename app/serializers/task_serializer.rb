class TaskSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :status, :order, :number, :start_date, :time_to_start, :time_to_finish
end
