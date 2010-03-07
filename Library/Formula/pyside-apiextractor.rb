require 'formula'

class PysideApiextractor <Formula
  @url='http://www.pyside.org/files/apiextractor-0.3.3.tar.bz2'
  @homepage='http://www.pyside.org/'
  @sha1='677789a1085506908c147896649b06cc62ef1c68'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'boost'

  def install
    FileUtils.mkdir 'apiextractor-build'

    Dir.chdir 'apiextractor-build' do
      system "cmake #{std_cmake_parameters} .."
      system "make"
      system "make install"
    end
  end
end
