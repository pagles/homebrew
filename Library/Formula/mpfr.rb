require 'formula'

class Mpfr <Formula
  @url='http://www.mpfr.org/mpfr-current/mpfr-2.4.2.tar.bz2'
  @homepage='http://www.mpfr.org/'
  @sha1='7ca93006e38ae6e53a995af836173cf10ee7c18c'

  depends_on 'gmp'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula.factory('gmp').prefix}",
                          "--disable-debug"
                          
    system "make"
    system "make install"
  end
end
