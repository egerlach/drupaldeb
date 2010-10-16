require 'dh_make_drupal'

class Release < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project_id
  validates_inclusion_of :drupal_version, :in => 5..7
  validates_inclusion_of :release_status, :in => ['recommended', 'developer']
  validates_inclusion_of :status, :in => ['Pending', 'OK']

  def before_save
    self.project.save
  end

  def validate
    info = DhMakeDrupal.get_project_info(self.project.code, self.drupal_version, self.release_status == 'developer')
    if info.nil?
      self.errors.add(:project_code, "Does not correspond to a valid project")
    else
      self.release_version = info[:release]
    end
  end

  def project_code
    return nil if self.project.nil?
    self.project.code
  end

  def project_code=(code)
    self.project = Project.find_or_create_by_code(code)
  end

  def build
    return unless self.status == "Pending"
    DhMakeDrupal.build_package(self.project.code, self.drupal_version, self.release_status == 'developer')
    self.status = "OK"
    self.save
  end
end
