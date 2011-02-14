require 'formula'

class NewLibArmEcos <Formula
  url       'ftp://sources.redhat.com/pub/newlib/newlib-1.19.0.tar.gz'
  homepage  'http://sourceware.org/newlib/'
  sha1      'b2269d30ce7b93b7c714b90ef2f40221c2df0fcd'

  def patches
    { :p1 => "http://www.moaningmarmot.info/newlib.patch" }
  end

end

class GppArmEcos <Formula
  url       'ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/snapshots/4.6-20110205/gcc-g++-4.6-20110205.tar.bz2'
  homepage  'http://gcc.gnu.org/'
  sha1      '3af28e211d12b25c845f1d721e5c7004eed50bc7'
end

class GobjcArmEcos <Formula
  url       'ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/snapshots/4.6-20110205/gcc-objc-4.6-20110205.tar.bz2'
  homepage  'http://gcc.gnu.org/'
  sha1      '7037424d5fd5fa98d9438431c906f7a98f42e182'
end

class GccArmEcos <Formula
  url       'ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/snapshots/4.6-20110205/gcc-core-4.6-20110205.tar.bz2'
  homepage  'http://gcc.gnu.org/'
  sha1      'b66e799bc00338e4ab7dd4d1a59abc44a5f12b15'

  depends_on 'gmp'
  depends_on 'mpfr'
  depends_on 'libmpc'
  depends_on 'ppl'
  depends_on 'cloog-ppl'
  depends_on 'libelf'
  depends_on 'binutils-arm-ecos'

  def patches
    DATA
  end

  def install
    
    # Ok, I stop fighting against Ruby (wish Homebrew was written in Python...)
    # Use the ditto system command to replicate the directories
    # If anyone knows how to extract an archive into an existing directory
    # with homebrew, please - let me know!
    coredir = Dir.pwd
    GppArmEcos.new.brew { system "ditto", Dir.pwd, coredir }
    GobjcArmEcos.new.brew { system "ditto", Dir.pwd, coredir }
    NewLibArmEcos.new.brew { 
        system "ditto", Dir.pwd+'/libgloss', coredir+'/libgloss'
        system "ditto", Dir.pwd+'/newlib', coredir+'/newlib' 
    }
    
    # Cannot build with LLVM (cross compiler crashes)
    ENV.gcc_4_2
    # Fix up CFLAGS for cross compilation (default switches cause build issues)
    ENV['CFLAGS_FOR_BUILD'] = "-O2"
    ENV['CFLAGS'] = "-O2"
    ENV['CFLAGS_FOR_TARGET'] = "-O2"
    ENV['CXXFLAGS_FOR_BUILD'] = "-O2"
    ENV['CXXFLAGS'] = "-O2"
    ENV['CXXFLAGS_FOR_TARGET'] = "-O2"

    build_dir='build'
    mkdir build_dir
    Dir.chdir build_dir do
      #system "exit 1"
      system "../configure", "--prefix=#{prefix}", "--target=arm-eabi",
                  "--disable-shared", "--with-gnu-as", "--with-gnu-ld",
                  "--with-newlib", "--enable-softfloat", "--disable-bigendian",
                  "--disable-fpu", "--disable-underscore", "--enable-multilibs",
                  "--with-float=soft", "--enable-interwork", "--disable-lto",
                  "--disable-plugin", "--with-multilib-list=interwork", 
                  "--with-abi=aapcs", "--enable-languages=c,c++,objc",
                  "--enable-threads=posix",
                  "--with-gmp=#{Formula.factory('gmp').prefix}",
                  "--with-mpfr=#{Formula.factory('mpfr').prefix}",
                  "--with-mpc=#{Formula.factory('libmpc').prefix}",
                  "--with-ppl=#{Formula.factory('ppl').prefix}",
                  "--with-cloog=#{Formula.factory('cloog-ppl').prefix}",
                  "--with-libelf=#{Formula.factory('libelf').prefix}",
                  "--with-gxx-include-dir=#{prefix}/arm-eabi/include",
                  "--disable-debug", "--disable-__cxa_atexit",
                  "--with-pkgversion=Neotion-SDK-Regina",
                  "--with-bugurl=http://www.neotion.com"
      system "make"
      system "make install"
    end

    ln_s "#{Formula.factory('binutils-arm-ecos').prefix}/arm-eabi/bin",
                   "#{prefix}/arm-eabi/bin"
  end
end

__END__
--- a/gcc/config/arm/t-arm-elf	2008-06-12 19:29:47.000000000 +0200
+++ b/gcc/config/arm/t-arm-elf	2010-01-14 00:44:48.000000000 +0100
@@ -65,8 +65,8 @@
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
