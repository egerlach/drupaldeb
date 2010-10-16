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
    return true unless self.release_version.nil?
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

  def updatable?
    return false if self.obsolete 
    info = DhMakeDrupal.get_project_info(self.project.code, self.drupal_version, self.release_status == 'developer')
    self.release_version != info[:release]
  end

  def self.update
    Release.find(:all).each do |r|
      if r.updatable?
        new_release = r.clone
        new_release.release_version = nil
        new_release.status = 'Pending'
        new_release.save
        r.obsolete = true
        r.save
      end
    end
  end

end
