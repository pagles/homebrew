require 'formula'

class CloogPpl <Formula
  url 'ftp://gcc.gnu.org/pub/gcc/infrastructure/cloog-ppl-0.15.10.tar.gz'
  homepage 'http://gcc.gnu.org/'
  sha1 '3d8725487a41e0f06c5d52daad74e279b555b833'

  depends_on 'gmp'
  depends_on 'ppl'
  depends_on 'gnu-libtool' => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula.factory('gmp').prefix}",
                          "--with-ppl=#{Formula.factory('ppl').prefix}"
    # I am SO tired of the autotools mess...
    # Replace the buggy generated libtool with the Homebrew one
    File.unlink "libtool"
    File.symlink "#{HOMEBREW_PREFIX}/bin/libtool", "libtool"
    system "make"
    system "make install"
  end
end
