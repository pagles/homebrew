require 'formula'

class PysideGeneratorrunner <Formula
  @url='http://www.pyside.org/files/generatorrunner-0.4.0.tar.bz2'
  @homepage='http://www.pyside.org/'
  @sha1='699eecc916a63afae5ba5c3054270019c90a5195'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'pyside-apiextractor'

  def install
    mkdir 'generatorrunner-build'

    cmake_version = `cmake --version 2>&1`.match('cmake version (\d+\.\d+)').captures.at(0)

    Dir.chdir 'generatorrunner-build' do
      system "cmake #{std_cmake_parameters} " \
             "-DCMAKE_MODULE_PATH=#{Formula.factory('pyside-apiextractor').prefix}/share/cmake-#{cmake_version}/Modules " \
             ".."
      system "make"
      system "make install"
    end
  end
end
