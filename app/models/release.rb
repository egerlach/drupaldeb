require 'dh_make_drupal'

class Release < ActiveRecord::Base
  belongs_to :project

  def build
    return unless self.status == "Pending"
    DhMakeDrupal.build_package(self.project.code, self.drupal_version, self.release_status)
    self.status = "OK"
  end
end
