require 'formula'

class Mpfr <Formula
  @url='http://mpfr.loria.fr/mpfr-3.0.0/mpfr-3.0.0.tar.bz2'
  @homepage='http://mpfr.loria.fr/'
  @sha1='8ae8bc72ac26a0f17ad9f57c520264c056c64770'

  depends_on 'gmp'

  def patches
    {:p1 => ['http://mpfr.loria.fr/mpfr-3.0.0/allpatches']}
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula.factory('gmp').prefix}",
                          "--disable-debug"
                          
    system "make install"
  end
end
