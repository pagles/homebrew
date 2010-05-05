require 'formula'

class Ppl <Formula
  @url='http://www.cs.unipr.it/ppl/Download/ftp/releases/0.10.2/ppl-0.10.2.tar.bz2'
  @homepage='http://www.cs.unipr.it/ppl/'
  @sha1='9af711df8f24658a6deb61ca3b8c5e82366258bf'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula.factory('gmp').prefix}",
                          "--with-mpfr=#{Formula.factory('mpfr').prefix}",
                          "--enable-optimization=sspeed"
    system "make"
    system "make install"
  end
end
