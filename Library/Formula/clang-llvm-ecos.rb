require 'formula'

class ClangLlvmEcos <Formula
  # this is llvm and clang repackaged as
  # homebrew makes things really hard when it comes to building from a
  # combination of various archives
  url 'http://dl.dropbox.com/u/2402907/llvm-2.9svn.tar.bz2'
  homepage 'http://clang.llvm.org/'
  md5 '5b6162c5e58398e447e9ad0dfe863289'
  version '2.9svn'

  depends_on 'gmp'
  depends_on 'mpfr'
  depends_on 'libmpc'
  depends_on 'ppl'
  depends_on 'cloog-ppl'
  depends_on 'libelf'
  depends_on 'binutils-arm-ecos'

  def install
    # Cannot build with LLVM (cross compiler crashes)
    #ENV.gcc_4_2
    # There appears to be parallelism issues.
    #ENV.j1
    # Fix up CFLAGS for cross compilation (default switches cause build issues)
    ENV['CFLAGS_FOR_BUILD'] = "-O2"
    ENV['CFLAGS'] = "-O2"
    ENV['CFLAGS_FOR_TARGET'] = "-O2"
    ENV['CXXFLAGS_FOR_BUILD'] = "-O2"
    ENV['CXXFLAGS'] = "-O2"
    ENV['CXXFLAGS_FOR_TARGET'] = "-O2"
    ENV.delete('LD')
    ENV.delete('LDFLAGS')

    system "./configure", "--prefix=#{prefix}", "--target=arm-eabi",
                "--disable-shared", "--with-gnu-as", "--with-gnu-ld",
                "--with-newlib", "--enable-softfloat", "--disable-bigendian",
                "--disable-fpu", "--disable-underscore", "--enable-multilibs",
                "--with-float=soft", "--enable-interwork",
                "--with-multilib-list=interwork", "--with-abi=aapcs",
                "--enable-languages=c,c++", "--disable-__cxa_atexit",
                "--with-gmp=#{Formula.factory('gmp').prefix}",
                "--with-mpfr=#{Formula.factory('mpfr').prefix}",
                "--with-mpc=#{Formula.factory('libmpc').prefix}",
                "--with-ppl=#{Formula.factory('ppl').prefix}",
                "--with-cloog=#{Formula.factory('cloog-ppl').prefix}",
                "--with-libelf=#{Formula.factory('libelf').prefix}",
                "--with-gxx-include-dir=#{prefix}/arm-eabi/include",
                "--disable-debug", "--enable-optimized",
                "--with-pkgversion=Neotion-SDK-Peneloppe",
                "--with-bugurl=http://www.neotion.com"
    system "make"
    system "make install"

    #ln_s "#{Formula.factory('binutils-arm-ecos').prefix}/arm-eabi/bin",
    #               "#{prefix}/arm-eabi/bin"
  end
end
