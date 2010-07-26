require 'formula'

class Libmpc <Formula
  @url='http://www.multiprecision.org/mpc/download/mpc-0.8.2.tar.gz'
  @homepage='http://www.multiprecision.org/'
  @sha1='339550cedfb013b68749cd47250cd26163b9edd4'

  depends_on 'gmp'
  depends_on 'mpfr'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula.factory('gmp').prefix}",
                          "--with-mpfr=#{Formula.factory('mpfr').prefix}"
                          
    system "make install"
  end
end
