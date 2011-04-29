require 'formula'

class PysideQt <Formula
  @url='http://www.pyside.org/files/pyside-qt4.6+0.3.0.tar.bz2'
  @homepage='http://www.pyside.org/'
  @sha1='c0cdaccada1f944b67afd189dd187c407a600876'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'pyside-apiextractor'
  depends_on 'pyside-generatorrunner'
  depends_on 'pyside-shiboken'

  def install
    mkdir 'qt-build'

    cmake_version = `cmake --version 2>&1`.match('cmake version (\d+\.\d+)').captures.at(0)
    api_path = "#{Formula.factory('pyside-apiextractor').prefix}/share/cmake-#{cmake_version}/Modules"
    gen_path = "#{Formula.factory('pyside-generatorrunner').prefix}/share/cmake-#{cmake_version}/Modules"
    shi_path = "#{Formula.factory('pyside-shiboken').prefix}/share/cmake-#{cmake_version}/Modules"

    Dir.chdir 'qt-build' do
      system "cmake #{std_cmake_parameters} " \
             "-DCMAKE_MODULE_PATH=#{api_path}:#{gen_path}:#{shi_path} " \
             ".."
      system "make"
      system "make install"
    end
  end
end
