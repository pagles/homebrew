require 'formula'

class GccArmEcos <Formula
  @url='http://qnap.moaningmarmot.info/public/gcc-ecos-4.4.3.tar.bz2'
  @homepage='http://gcc.gnu.org/'
  @sha1='05565e09eac268cee5bd2bb55addc12882c59ca0'

  depends_on 'gmp'
  depends_on 'mpfr'
  depends_on 'ppl'
  depends_on 'cloog-ppl'
  depends_on 'libelf'
  depends_on 'binutils-arm-ecos'

  def patches
    DATA
  end

  def install
    # Fix up CFLAGS for cross compilation
    #ENV['CFLAGS_FOR_BUILD'] = ENV['CFLAGS'] + " -O2"
    ENV['CFLAGS_FOR_BUILD'] = "-O2"
    ENV['CFLAGS'] = "-O2"
    ENV['CFLAGS_FOR_TARGET'] = "-O2"
    #ENV['CXXFLAGS_FOR_BUILD'] = ENV['CXXFLAGS'] + " -O2"
    ENV['CXXFLAGS_FOR_BUILD'] = "-O2"
    ENV['CXXFLAGS'] = "-O2"
    ENV['CXXFLAGS_FOR_TARGET'] = "-O2"
    # Cannot build with LLVM
    ENV.gcc_4_2
    
    build_dir='build'
    FileUtils.mkdir build_dir
    Dir.chdir build_dir do
      system "../configure", "--prefix=#{prefix}", "--target=arm-eabi",
                  "--disable-shared", "--with-gnu-as", "--with-gnu-ld",
                  "--with-newlib", "--enable-softfloat", "--disable-bigendian",
                  "--disable-fpu", "--disable-underscore", "--enable-multilibs",
                  "--with-float=soft", "--enable-interwork", "--with-fpu=fpa",
                  "--with-multilib-list=interwork", "--with-abi=aapcs",
                  "--enable-languages=c,c++", "--disable-__cxa_atexit",
                  "--with-gmp=#{Formula.factory('gmp').prefix}",
                  "--with-mpfr=#{Formula.factory('mpfr').prefix}",
                  "--with-ppl=#{Formula.factory('ppl').prefix}",
                  "--with-cloog=#{Formula.factory('cloog-ppl').prefix}",
                  "--with-libelf=#{Formula.factory('libelf').prefix}",
                  "--with-gxx-include-dir=$PREFIX/$TARGET/include",
                  "--disable-debug"
      system "make"
      system "make install"
    end
    
    FileUtils.ln_s "#{Formula.factory('binutils-arm-ecos').prefix}/arm-eabi/bin",
                   "#{prefix}/arm-eabi/bin"
  end
end

__END__
--- a/gcc/config/arm/t-arm-elf	2008-06-12 19:29:47.000000000 +0200
+++ b/gcc/config/arm/t-arm-elf	2010-01-14 00:44:48.000000000 +0100
@@ -40,8 +40,8 @@
 # MULTILIB_DIRNAMES   += fpu soft
 # MULTILIB_EXCEPTIONS += *mthumb/*mhard-float*
 # 
-# MULTILIB_OPTIONS    += mno-thumb-interwork/mthumb-interwork
-# MULTILIB_DIRNAMES   += normal interwork
+MULTILIB_OPTIONS    += mno-thumb-interwork/mthumb-interwork
+MULTILIB_DIRNAMES   += normal interwork
 # 
 # MULTILIB_OPTIONS    += fno-leading-underscore/fleading-underscore
 # MULTILIB_DIRNAMES   += elf under
