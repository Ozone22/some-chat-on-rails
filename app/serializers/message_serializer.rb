class MessageSerializer < ActiveModel::Serializer
  attributes :id, :text, :dialog_id, :dialog_type, :sender_id, :created_at
end
