class Task < ApplicationRecord
  enum status: {
    in_progress: 0, # Em andamento
    overdue: 1,     # Em atraso
    completed: 2,   # Concluída
    cancelled: 3    # Cancelada
  }

  validates :title, presence: true
  validates :status, presence: true

  # Callback para verificar o status "Em atraso"
  before_save :check_overdue_status, if: :will_save_change_to_due_date?

  scope :by_status, ->(status) { where(status: status) }
  scope :by_title, ->(title) { where("title ILIKE ?", "%#{title}%") }
  scope :by_description, ->(description) { where("description ILIKE ?", "%#{description}%") }
  scope :by_created_at, ->(date) { where(created_at: date.all_day) } # Para buscar pelo dia inteiro
  scope :by_due_date, ->(date) { where(due_date: date.all_day) } # Para buscar pelo dia inteiro

  private

  def check_overdue_status
    if due_date.present? && !completed? && !cancelled? && due_date < Date.current
      self.status = :overdue
    end
  end
end
