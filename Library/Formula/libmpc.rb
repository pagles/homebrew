require 'formula'

class Libmpc < Formula
  url 'http://multiprecision.org/mpc/download/mpc-0.8.2.tar.gz'
  homepage 'http://multiprecision.org'
  md5 'e98267ebd5648a39f881d66797122fb6'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula.factory('gmp').prefix}",
                          "--with-mpfr=#{Formula.factory('mpfr').prefix}",
                          "--disable-debug"
                          
    system "make install"
  end
end
