require 'formula'

class Mpc <Formula
  @url='http://www.multiprecision.org/mpc/download/mpc-0.8.1.tar.gz'
  @homepage='http://www.multiprecision.org/'
  @sha1='5ef03ca7aee134fe7dfecb6c9d048799f0810278'

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
