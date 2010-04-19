require 'formula'

class PysideShiboken <Formula
  @url='http://www.pyside.org/files/shiboken-0.2.0.tar.bz2'
  @homepage='http://www.pyside.org/'
  @sha1='36372e62d429d319dc99b28bb98264e3ec7cccc6'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'pyside-apiextractor'
  depends_on 'pyside-generatorrunner'

  def install
    FileUtils.mkdir 'shiboken-build'
    
    cmake_version = `cmake --version 2>&1`.match('cmake version (\d+\.\d+)').captures.at(0)
    api_path = "#{Formula.factory('pyside-apiextractor').prefix}/share/cmake-#{cmake_version}/Modules"
    gen_path = "#{Formula.factory('pyside-generatorrunner').prefix}/share/cmake-#{cmake_version}/Modules"
    
    Dir.chdir 'shiboken-build' do
      system "cmake #{std_cmake_parameters} " \
             "-DCMAKE_MODULE_PATH=#{api_path}:#{gen_path} " \
             ".."
      system "make"
      system "make install"
    end
  end
end
