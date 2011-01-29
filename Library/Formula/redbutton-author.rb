require 'formula'

class RedbuttonAuthor <Formula
  url 'http://sourceforge.net/projects/redbutton/files/current/redbutton-author-20090727.tar.gz'
  homepage 'http://redbutton.sourceforge.net/'
  md5 '373ce10d1de8a6b84782818b0b1f54e4'

  def patches
    DATA
  end

  def install
    # badly written Makefile
    ENV.deparallelize
    system "make"
    system "make install INSTALLDIR=#{prefix}"
  end
end

__END__
--- a/Makefile	2009-07-27 15:52:12.000000000 +0200
+++ b/Makefile	2011-01-29 22:12:01.000000000 +0100
@@ -11,7 +11,7 @@
 #LEX=lex
 #YACC=yacc
 
-DESTDIR=/usr/local
+DESTDIR=$(INSTALLDIR)
 
 MHEGC_OBJS=	mhegc.o	\
 		lex.parser.o	\
