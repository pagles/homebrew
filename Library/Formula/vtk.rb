require 'formula'

class Vtk <Formula
  @url='http://www.vtk.org/files/release/5.4/vtk-5.4.2.tar.gz'
  @homepage='http://www.vtk.org/'
  @sha1='508106a15c32326aa9ac737c7f0e7212c150d55f'

  depends_on 'cmake'

  def install
    FileUtils.mkdir 'vtk-build'

    Dir.chdir 'vtk-build' do
      system "cmake #{std_cmake_parameters} " \
             "-DBUILD_SHARED_LIBS=ON " \
             "-DBUILD_TESTING=OFF " \
             "-DBUILD_EXAMPLES=OFF " \
             "-DVTK_WRAP_PYTHON=ON "
      system "make"
      system "make install"
    end
  end
end
