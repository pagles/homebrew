require 'formula'

class WxmacGizmos <Formula
  url 'http://downloads.sourceforge.net/project/wxcode/Components/gizmos/gizmos.tar.gz'
  homepage 'http://sourceforge.net/projects/wxcode/'
  md5 '6630ca75805262634537af4c8317dc0b'
  version='1.0'

#  depends_on 'wxmac'

  def patches
    DATA
  end

  def install
    # Force i386
    %w{ CFLAGS CXXFLAGS LDFLAGS OBJCFLAGS OBJCXXFLAGS }.each do |compiler_flag|
      ENV.remove compiler_flag, "-arch x86_64"
      ENV.append compiler_flag, "-arch i386"
      ENV.append "DYLD_FALLBACK_LIBRARY_PATH", "."
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end


__END__
--- a/configure	2009-12-19 16:47:05.000000000 +0100
+++ b/configure	2009-12-19 16:49:52.000000000 +0100
@@ -2496,11 +2496,11 @@
 
       { echo "$as_me:$LINENO: result: yes (version $WX_VERSION_FULL)" >&5
 echo "${ECHO_T}yes (version $WX_VERSION_FULL)" >&6; }
-      WX_LIBS=`$WX_CONFIG_WITH_ARGS --libs`
+      WX_LIBS=`$WX_CONFIG_WITH_ARGS --libs html`
 
                               { echo "$as_me:$LINENO: checking for wxWidgets static library" >&5
 echo $ECHO_N "checking for wxWidgets static library... $ECHO_C" >&6; }
-      WX_LIBS_STATIC=`$WX_CONFIG_WITH_ARGS --static --libs 2>/dev/null`
+      WX_LIBS_STATIC=`$WX_CONFIG_WITH_ARGS --static --libs html 2>/dev/null`
       if test "x$WX_LIBS_STATIC" = "x"; then
         { echo "$as_me:$LINENO: result: no" >&5
 echo "${ECHO_T}no" >&6; }
