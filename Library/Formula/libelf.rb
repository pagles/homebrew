require 'formula'

class Libelf <Formula
  @url='http://www.mr511.de/software/libelf-0.8.13.tar.gz'
  @homepage='http://www.mr511.de/software/english.html'
  @sha1='c1d6ac5f182d19dd685c4dfd74eedbfe3992425d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"
    system "make install"
  end
end
