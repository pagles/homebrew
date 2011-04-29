require 'formula'

class WxmacGizmos <Formula
  @url='http://downloads.sourceforge.net/project/wxcode/Components/gizmos/gizmos.tar.gz'
  @homepage='http://sourceforge.net/projects/wxcode/'
  @md5='6630ca75805262634537af4c8317dc0b'
  @version='1.0'

  depends_on 'wxmac'

  def patches
    DATA
  end

  def install
    # Force i386
    %w{ CFLAGS CXXFLAGS LDFLAGS OBJCFLAGS OBJCXXFLAGS }.each do |compiler_flag|
      ENV.remove compiler_flag, "-arch x86_64"
      ENV.append compiler_flag, "-arch i386"
    end
    ENV.append "DYLD_FALLBACK_LIBRARY_PATH", "."

    system "./configure", "--prefix=#{prefix}",
           "--with-wx-config=#{Formula.factory('wxmac').prefix}/bin/wx-config"
    system "make"
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
--- a/Makefile.in	2009-12-19 17:54:32.000000000 +0100
+++ b/Makefile.in	2009-12-19 17:56:07.000000000 +0100
@@ -104,8 +104,8 @@
 @COND_WX_SHARED_0@__gizmos_lib___depname = $(COND_WX_SHARED_0___gizmos_lib___depname)
 @COND_WX_SHARED_0@__install_gizmos_lib___depname = install_gizmos_lib
 @COND_WX_SHARED_0@__uninstall_gizmos_lib___depname = uninstall_gizmos_lib
-@COND_WX_SHARED_0@__install_gizmos_lib_headers___depname \
-@COND_WX_SHARED_0@	= install_gizmos_lib_headers
+__install_gizmos_lib_headers___depname \
+	= install_gizmos_lib_headers
 @COND_WX_SHARED_0@__uninstall_gizmos_lib_headers___depname \
 @COND_WX_SHARED_0@	= uninstall_gizmos_lib_headers
 COND_WX_SHARED_1___gizmos_dll___depname = \
@@ -247,14 +247,14 @@
 @COND_WX_SHARED_0@uninstall_gizmos_lib: 
 @COND_WX_SHARED_0@	rm -f $(DESTDIR)$(libdir)/$(LIBPREFIX)wxcode_$(WX_PORT)$(WXLIBPOSTFIX)_gizmos-$(WX_VERSION_MAJOR).$(WX_VERSION_MINOR)$(LIBEXT)
 
-@COND_WX_SHARED_0@install_gizmos_lib_headers: 
-@COND_WX_SHARED_0@	$(INSTALL_DIR) $(DESTDIR)$(prefix)
-@COND_WX_SHARED_0@	for f in ; do \
-@COND_WX_SHARED_0@	if test ! -d $(DESTDIR)$(prefix)/`dirname $$f` ; then \
-@COND_WX_SHARED_0@	$(INSTALL_DIR) $(DESTDIR)$(prefix)/`dirname $$f`; \
-@COND_WX_SHARED_0@	fi; \
-@COND_WX_SHARED_0@	$(INSTALL_DATA) $(srcdir)/$$f $(DESTDIR)$(prefix)/$$f; \
-@COND_WX_SHARED_0@	done
+install_gizmos_lib_headers: 
+	$(INSTALL_DIR) $(DESTDIR)$(prefix)
+	for f in `find $(srcdir)/include/wx/gizmos -name "*.h" -print`; do \
+	if test ! -d $(DESTDIR)$(prefix)/`dirname $$f` ; then \
+	$(INSTALL_DIR) $(DESTDIR)$(prefix)/`dirname $$f`; \
+	fi; \
+	$(INSTALL_DATA) $(srcdir)/$$f $(DESTDIR)$(prefix)/$$f; \
+	done
 
 @COND_WX_SHARED_0@uninstall_gizmos_lib_headers: 
 @COND_WX_SHARED_0@	for f in ; do \
