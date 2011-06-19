class Reprepro
  REPREPRO_OPTIONS = 
    ' --basedir=' + File.join(File.dirname(__FILE__), '../db/reprepro')     +
    ' --confdir=' + File.join(File.dirname(__FILE__), '../config/reprepro') + 
    ' --outdir='  + File.join(File.dirname(__FILE__), '../public/debian')   +
    ' --ignore=wrongdistribution --silent '

  REPREPRO_COMMAND = '/usr/bin/reprepro' + REPREPRO_OPTIONS

  def self.include(codename, filename)
    system(REPREPRO_COMMAND + ' include ' + codename + ' ' + filename)
  end
end
