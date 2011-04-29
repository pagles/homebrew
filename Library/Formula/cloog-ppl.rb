require 'formula'

class CloogPpl <Formula
  url 'http://www.bastoul.net/cloog/pages/download/cloog-0.16.2.tar.gz'
  homepage 'http://gcc.gnu.org/'
  sha1 '3bdccfe24e5bd5850cbd28eec70c6aeaa94747ab'

  depends_on 'gmp'
  depends_on 'ppl'
  depends_on 'gnu-libtool' => :build

  def install
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
