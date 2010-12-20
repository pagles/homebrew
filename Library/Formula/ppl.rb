require 'formula'

class Ppl <Formula
  url 'http://www.cs.unipr.it/ppl/Download/ftp/releases/0.11/ppl-0.11.tar.bz2'
  homepage 'http://www.cs.unipr.it/ppl/'
  sha1 'bcba279c2600833876e3002635ab47cacab632d5'

  depends_on 'gmp'
  depends_on 'mpfr'

  # Note: if ppl fails to build with a "was defined here" error, you may want
  # to move a previous installation of PPL out of the way during the build
  #   move Cellar/ppl/0.10.2 ~/ppl
  #   brew install ppl
  #   move ~/ppl Cellar/ppl/0.10.2
  def install
    ENV.append "CFLAGS", "-D__GMP_BITS_PER_MP_LIMB=GMP_NUMB_BITS"
    ENV.append "CXXFLAGS", "-D__GMP_BITS_PER_MP_LIMB=GMP_NUMB_BITS"
    args = ["--prefix=#{prefix}",
            "--with-gmp=#{Formula.factory('gmp').prefix}",
            "--with-mpfr=#{Formula.factory('mpfr').prefix}",
            "--enable-optimization=sspeed"]
    args << "--enable-arch=x86-64" if Hardware.is_64_bit? and MACOS_VERSION >= 10.6

    system './configure', *args
    system "make"
    system "make install"
  end
end
