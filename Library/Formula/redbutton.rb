require 'formula'

class Redbutton <Formula
  url 'svn://redbutton.svn.sourceforge.net/svnroot/redbutton/redbutton-author/tags/redbutton-author-20090727/'
  version '20090727'
  homepage 'http://redbutton.sourceforge.net/'
  md5 '35badff09f989c64bf5db1e56c77c328'

  # depends_on 'cmake'

  def install
    # badly written Makefile
    ENV.deparallelize
    system "make"
    system "make install"
  end
end
