require 'formula'

class RedbuttonAuthor <Formula
  url 'http://sourceforge.net/projects/redbutton/files/current/redbutton-author-20090727.tar.gz'
  homepage 'http://redbutton.sourceforge.net/'
  md5 '373ce10d1de8a6b84782818b0b1f54e4'

  # depends_on 'cmake'

  def install
    # badly written Makefile
    ENV.deparallelize
    system "make"
    system "make install"
  end
end
