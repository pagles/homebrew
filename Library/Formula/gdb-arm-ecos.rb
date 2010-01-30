require 'formula'

class GdbArmEcos <Formula
  @url='http://ftp.gnu.org/gnu/gdb/gdb-7.0.1.tar.bz2'
  @homepage='http://www.gnu.org/software/gdb/'
  @sha1='a6b9693b5767dd3b1a3fa925563252afd20eea64'

  depends_on 'gmp'
  depends_on 'mpfr'
  depends_on 'ppl'
  depends_on 'cloog-ppl'

  def install
    system "./configure", "--prefix=#{prefix}", "--target=arm-eabi",
                "--with-gmp=#{Formula.factory('gmp').prefix}",
                "--with-mpfr=#{Formula.factory('mpfr').prefix}",
                "--with-ppl=#{Formula.factory('ppl').prefix}",
                "--with-cloog=#{Formula.factory('cloog-ppl').prefix}",
                "--disable-werror"
    system "make"
    system "make install"
  end
end
