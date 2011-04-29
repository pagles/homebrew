require 'formula'

class PysideApiextractor <Formula
  @url='http://www.pyside.org/files/apiextractor-0.4.0.tar.bz2'
  @homepage='http://www.pyside.org/'
  @sha1='cfba532583a3a33c8b27df5236d78b2bee208000'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'boost'

  def install
    mkdir 'apiextractor-build'

    Dir.chdir 'apiextractor-build' do
      system "cmake #{std_cmake_parameters} .."
      system "make"
      system "make install"
    end
  end
end
