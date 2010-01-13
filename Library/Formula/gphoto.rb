require 'formula'

class Gphoto <Formula
  @url='http://downloads.sourceforge.net/project/gphoto/gphoto/2.4.7/gphoto2-2.4.7.tar.bz2'
  @homepage='http://gphoto.sourceforge.net'
  @md5='a0bd7629040735f16e510b63edf386dd'
  
  depends_on 'libgphoto'
  depends_on 'popt'
  
  def install
    system "./configure", "--prefix=#{prefix}", "--without-readline"
    system "make"
    system "make install"
  end
end
