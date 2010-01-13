require 'formula'

class CloogPpl <Formula
  @url='http://gcc-uk.internet.bs/infrastructure/cloog-ppl-0.15.7.tar.gz'
  @homepage='http://gcc.gnu.org/'
  @sha1='dfcc68838d715af8a87f763d3a1cd30531f7dfdd'

  depends_on 'gmp'
  depends_on 'ppl'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-gmp=#{Formula.factory('gmp').prefix}",
                          "--with-ppl=#{Formula.factory('ppl').prefix}"
    system "make"
    system "make install"
  end
end
