require 'formula'

class PysideBoostpythongenerator <Formula
  @url='http://www.pyside.org/files/boostpythongenerator-0.3.3.tar.bz2'
  @homepage='http://www.pyside.org/'
  @sha1='56c4b9a8782332aa685457461c50befe26b34d76'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'pyside-apiextractor'
  depends_on 'pyside-generatorrunner'

  def install
    FileUtils.mkdir 'boostpythongenerator-build'
    
    cmake_version = `cmake --version 2>&1`.match('cmake version (\d+\.\d+)').captures.at(0)
    api_path = "#{Formula.factory('pyside-apiextractor').prefix}/share/cmake-#{cmake_version}/Modules"
    gen_path = "#{Formula.factory('pyside-generatorrunner').prefix}/share/cmake-#{cmake_version}/Modules"
    
    Dir.chdir 'boostpythongenerator-build' do
      system "cmake #{std_cmake_parameters} " \
             "-DCMAKE_MODULE_PATH=\"#{api_path};#{gen_path}\" " \
             ".."
      system "make"
      system "make install"
    end
  end
end
