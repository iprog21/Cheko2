class ConversationSource < ApplicationRecord
  belongs_to :conversation, optional: true
end
