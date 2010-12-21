require 'formula'

class GdbArmEcos <Formula
  url 'http://ftp.gnu.org/gnu/gdb/gdb-7.2.tar.bz2'
  homepage 'http://www.gnu.org/software/gdb/'
  md5 '64260e6c56979ee750a01055f16091a5'

  depends_on 'gmp'
  depends_on 'mpfr'
  depends_on 'ppl'
  depends_on 'cloog-ppl'

  def install
    # Cannot build with LLVM (cross compiler crashes)
    ENV.gcc_4_2
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
