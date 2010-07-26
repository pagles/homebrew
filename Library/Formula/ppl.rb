require 'formula'

class Ppl <Formula
  @url='http://www.cs.unipr.it/ppl/Download/ftp/releases/0.10.2/ppl-0.10.2.tar.bz2'
  @homepage='http://www.cs.unipr.it/ppl/'
  @sha1='9af711df8f24658a6deb61ca3b8c5e82366258bf'

  if ARGV.build_head?
    md5 '14f4d5297a161f9ba22c33945fc61a27'
  else
    md5 '5667111f53150618b0fa522ffc53fc3e'
  end

  depends_on 'gmp'
  depends_on 'mpfr'

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
