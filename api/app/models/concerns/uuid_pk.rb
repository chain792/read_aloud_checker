module UuidPk
  extend ActiveSupport::Concern

  included do
    before_create :set_uuid
  end

  def set_uuid
    self.id = SecureRandom.uuid
  end
end
