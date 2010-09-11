require 'formula'

class Libftdi <Formula
  @url="git://developer.intra2net.com/libftdi-1.0/"
  @homepage='http://www.intra2net.com/en/developer/libftdi'
  @version='0.18'
  # @url="http://www.intra2net.com/en/developer/libftdi/download/libftdi-0.17.tar.gz"
  # @md5='810c69cfaa078b49795c224ef9b6b851'

  depends_on 'cmake'
  depends_on 'boost'
  depends_on 'libusb'

  def patches
    DATA
  end

  def install
    mkdir 'libftdi-build'
    Dir.chdir 'libftdi-build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make"
      system "make install"
    end
  end
end

__END__
--- a/CMakeLists.txt	2010-06-10 23:33:04.000000000 +0200
+++ b/CMakeLists.txt	2010-06-11 00:01:57.000000000 +0200
@@ -26,6 +26,11 @@
 FIND_PACKAGE(USB1 REQUIRED)
 INCLUDE_DIRECTORIES(${LIBUSB_INCLUDE_DIR})
 
+find_package(Boost)
+if(Boost_FOUND)
+  include_directories(${Boost_INCLUDE_DIRS})
+endif(Boost_FOUND)
+
 # Set components
 set(CPACK_COMPONENTS_ALL sharedlibs staticlibs headers)
 set(CPACK_COMPONENT_SHAREDLIBS_DISPLAY_NAME "Shared libraries")
@@ -43,14 +48,19 @@
 set(CPACK_COMPONENT_STATICLIBS_GROUP "Development")
 set(CPACK_COMPONENT_HEADERS_GROUP    "Development")
 
-# Create suffix to eventually install in lib64
-IF(CMAKE_SIZEOF_VOID_P EQUAL 4)
+if(NOT APPLE)
+  # Create suffix to eventually install in lib64
+  if(CMAKE_SIZEOF_VOID_P EQUAL 4)
+      SET(LIB_SUFFIX "")
+      SET(PACK_ARCH "")
+    else(CMAKE_SIZEOF_VOID_P EQUAL 8)
+      SET(LIB_SUFFIX 64)
+      SET(PACK_ARCH .x86_64)
+  endif(CMAKE_SIZEOF_VOID_P EQUAL 4)
+else(NOT APPLE)
     SET(LIB_SUFFIX "")
     SET(PACK_ARCH "")
-  ELSE(CMAKE_SIZEOF_VOID_P EQUAL 8)
-    SET(LIB_SUFFIX 64)
-    SET(PACK_ARCH .x86_64)
-endif(CMAKE_SIZEOF_VOID_P EQUAL 4)
+endif(NOT APPLE)
 
 # Package information
 set(CPACK_PACKAGE_VERSION              ${VERSION_STRING})
@@ -90,8 +100,6 @@
 
 add_subdirectory(src)
 add_subdirectory(ftdipp)
-add_subdirectory(bindings)
-add_subdirectory(examples)
 add_subdirectory(packages)
 
 
--- a/src/ftdi.c	2010-06-10 23:33:04.000000000 +0200
+++ b/src/ftdi.c	2010-06-10 23:13:03.000000000 +0200
@@ -48,6 +48,9 @@
    } while(0);
 
 
+#define FTDI_BAUDRATE_REF_CLOCK 3000000 /* 3 MHz */
+#define FTDI_BAUDRATE_TOLERANCE       3 /* acceptable clock drift, in % */
+
 /**
     Internal function to close usb device pointer.
     Sets ftdi->usb_dev to NULL.
@@ -953,14 +956,28 @@
     int divisor, best_divisor, best_baud, best_baud_diff;
     unsigned long encoded_divisor;
     int i;
-
+    unsigned int ref_clock = FTDI_BAUDRATE_REF_CLOCK;
+    int hispeed = 0;
+    
     if (baudrate <= 0)
     {
         // Return error
         return -1;
     }
 
-    divisor = 24000000 / baudrate;
+    if ( (ftdi->type == TYPE_4232H) || (ftdi->type == TYPE_2232H) )
+    {
+        // these chips can support a 12MHz clock in addition to the original
+        // 3MHz clock. This allows higher baudrate (up to 12Mbps) and more
+        // precise baudrates for baudrate > 3Mbps/2
+        if ( baudrate > (FTDI_BAUDRATE_REF_CLOCK>>1) )
+        {
+            ref_clock *= 4; // 12 MHz
+            hispeed = 1;
+        }
+    }
+    
+    divisor = (ref_clock<<3) / baudrate;
 
     if (ftdi->type == TYPE_AM)
     {
@@ -978,45 +995,49 @@
         int baud_estimate;
         int baud_diff;
 
-        // Round up to supported divisor value
-        if (try_divisor <= 8)
-        {
-            // Round up to minimum supported divisor
-            try_divisor = 8;
-        }
-        else if (ftdi->type != TYPE_AM && try_divisor < 12)
-        {
-            // BM doesn't support divisors 9 through 11 inclusive
-            try_divisor = 12;
-        }
-        else if (divisor < 16)
+        if ( ! hispeed )
         {
-            // AM doesn't support divisors 9 through 15 inclusive
-            try_divisor = 16;
-        }
-        else
-        {
-            if (ftdi->type == TYPE_AM)
+            // Round up to supported divisor value
+            if (try_divisor <= 8)
             {
-                // Round up to supported fraction (AM only)
-                try_divisor += am_adjust_up[try_divisor & 7];
-                if (try_divisor > 0x1FFF8)
-                {
-                    // Round down to maximum supported divisor value (for AM)
-                    try_divisor = 0x1FFF8;
-                }
+                // Round up to minimum supported divisor
+                try_divisor = 8;
+            }
+            else if (ftdi->type != TYPE_AM && try_divisor < 12)
+            {
+                // BM doesn't support divisors 9 through 11 inclusive
+                try_divisor = 12;
+            }
+            else if ( divisor < 16 )
+            {
+                // AM doesn't support divisors 9 through 15 inclusive
+                try_divisor = 16;
             }
             else
             {
-                if (try_divisor > 0x1FFFF)
+                if (ftdi->type == TYPE_AM)
                 {
-                    // Round down to maximum supported divisor value (for BM)
-                    try_divisor = 0x1FFFF;
+                    // Round up to supported fraction (AM only)
+                    try_divisor += am_adjust_up[try_divisor & 7];
+                    if (try_divisor > 0x1FFF8)
+                    {
+                        // Round down to maximum supported divisor value (for AM)
+                        try_divisor = 0x1FFF8;
+                    }
+                }
+                else
+                {
+                    if (try_divisor > 0x1FFFF)
+                    {
+                        // Round down to maximum supported divisor value (for BM)
+                        try_divisor = 0x1FFFF;
+                    }
                 }
             }
         }
+
         // Get estimated baud rate (to nearest integer)
-        baud_estimate = (24000000 + (try_divisor / 2)) / try_divisor;
+        baud_estimate = ((ref_clock<<3) + (try_divisor / 2)) / try_divisor;
         // Get absolute difference from requested baud rate
         if (baud_estimate < baudrate)
         {
@@ -1059,7 +1080,13 @@
         *index |= ftdi->index;
     }
     else
+    {
         *index = (unsigned short)(encoded_divisor >> 16);
+    }
+    if ( hispeed )
+    {
+        *index |= 1<<9; // use hispeed mode
+    }
 
     // Return the nearest baud rate
     return best_baud;
