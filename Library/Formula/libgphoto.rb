require 'formula'

class Libgphoto <Formula
  @url='http://downloads.sourceforge.net/project/gphoto/libgphoto/2.4.7/libgphoto2-2.4.7.tar.bz2'
  @homepage='http://gphoto.sourceforge.net'
  @md5='3c1f1b1e56214e83b97e2bc7aadba4c5'
  
  def install
    system "./configure", "--prefix=#{prefix}", 
           "--disable-dependency-tracking", "--disable-debug"
    system "make"
    system "make install"
  end
end
