require 'formula'

class Libusb <Formula
  @url='http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.8/libusb-1.0.8.tar.bz2'
  @homepage='http://libusb.sourceforge.net'
  @sha1='5484397860f709c9b51611d224819f8ed5994063'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
