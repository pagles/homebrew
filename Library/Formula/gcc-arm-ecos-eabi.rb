require 'formula'

class NewLibArmEcosEabi <Formula
  url       'ftp://sources.redhat.com/pub/newlib/newlib-1.19.0.tar.gz'
  homepage  'http://sourceware.org/newlib/'
  sha1      'b2269d30ce7b93b7c714b90ef2f40221c2df0fcd'

  def patches
    { :p1 => "https://gist.github.com/raw/834649/2f4d1eaf503633ff6c3e61bdd0188c7534620b8d/newlib.patch" }
  end

end

class GppArmEcosEabi <Formula
  url       'ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/releases/gcc-4.6.0/gcc-g++-4.6.0.tar.bz2'
  homepage  'http://gcc.gnu.org/'
  sha1      '17f8810a7bbba95f333ff7eadaefe21924ec923b'
end

class GobjcArmEcosEabi <Formula
  url       'ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/releases/gcc-4.6.0/gcc-objc-4.6.0.tar.bz2'
  homepage  'http://gcc.gnu.org/'
  sha1      'b5814a9935904ee80cb698963985725153590595'

  def patches
    { :p1 => "https://gist.github.com/raw/834646/9f41eaa9a67db5d554f44108cde959a1d31bc732/objc.patch" }
  end

end

class GccArmEcosEabi <Formula
  url       'ftp://ftp.irisa.fr/pub/mirrors/gcc.gnu.org/gcc/releases/gcc-4.6.0/gcc-core-4.6.0.tar.bz2'
  homepage  'http://gcc.gnu.org/'
  sha1      '108e2d737666e18b2472f4a9223dae1c1a3ece5c'

  depends_on 'gmp'
  depends_on 'mpfr'
  depends_on 'libmpc'
  depends_on 'ppl'
  depends_on 'cloog-ppl'
  depends_on 'libelf'
  depends_on 'binutils-arm-ecos-eabi'

  def patches
    { :p1 => "https://gist.github.com/raw/902529/b62d529c070fee210a99e805f0178cd52ba965dd/gcc.patch" }
  end

  def install

    target = 'arm-ecos-eabi'
    
    # Ok, I stop fighting against Ruby (wish Homebrew was written in Python...)
    # Use the ditto system command to replicate the directories
    # If anyone knows how to extract an archive into an existing directory
    # with homebrew, please - let me know!
    coredir = Dir.pwd
    GppArmEcosEabi.new.brew { system "ditto", Dir.pwd, coredir }
    GobjcArmEcosEabi.new.brew { system "ditto", Dir.pwd, coredir }
    NewLibArmEcosEabi.new.brew { 
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
      system "../configure", "--prefix=#{prefix}", "--target="+target,
                  "--disable-shared", "--with-gnu-as", "--with-gnu-ld",
                  "--with-newlib", "--enable-softfloat", "--disable-bigendian",
                  "--disable-fpu", "--disable-underscore", "--enable-multilibs",
                  "--with-float=soft", "--enable-interwork", "--disable-lto",
                  "--disable-plugin", "--with-multilib-list=interwork", 
                  "--with-abi=aapcs", "--enable-languages=c,c++,objc",
                  "--enable-threads=posix", "--enable-cloog-backend=isl",
                  "--with-gmp=#{Formula.factory('gmp').prefix}",
                  "--with-mpfr=#{Formula.factory('mpfr').prefix}",
                  "--with-mpc=#{Formula.factory('libmpc').prefix}",
                  "--with-ppl=#{Formula.factory('ppl').prefix}",
                  "--with-cloog=#{Formula.factory('cloog-ppl').prefix}",
                  "--with-libelf=#{Formula.factory('libelf').prefix}",
                  "--with-gxx-include-dir=#{prefix}/"+target+"/include",
                  "--disable-debug", "--disable-__cxa_atexit",
                  "--with-pkgversion=Neotion-SDK-experimental",
                  "--with-bugurl=http://www.neotion.com"
      system "make"
      system "make install"
    end

    ln_s "#{Formula.factory('binutils-'+target).prefix}/"+target+"/bin",
                   "#{prefix}/"+target+"/bin"
  end
end
