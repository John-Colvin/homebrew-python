class DvipngRequirement < Requirement
  fatal false
  cask "matctex"

  satisfy { which("dvipng") }

  def message
    s = <<-EOS.undent
      `dvipng` not found. This is optional for Matplotlib.
    EOS
    s += super
    s
  end
end

class NoExternalPyCXXPackage < Requirement
  fatal false

  satisfy do
    !quiet_system "python", "-c", "import CXX"
  end

  def message; <<-EOS.undent
    *** Warning, PyCXX detected! ***
    On your system, there is already a PyCXX version installed, that will
    probably make the build of Matplotlib fail. In python you can test if that
    package is available with `import CXX`. To get a hint where that package
    is installed, you can:
        python -c "import os; import CXX; print(os.path.dirname(CXX.__file__))"
    See also: https://github.com/Homebrew/homebrew-python/issues/56
    EOS
  end
end

class Matplotlib < Formula
  desc "Python 2D plotting library"
  homepage "http://matplotlib.org"
  url "https://pypi.python.org/packages/75/4e/2374eed18ac34421ccd7b4907080abd3009e112ca2c11b100c18961312e0/matplotlib-1.5.3.tar.gz"
  sha256 "a0a5dc39f785014f2088fed2c6d2d129f0444f71afbb9c44f7bdf1b14d86ebbc"
  head "https://github.com/matplotlib/matplotlib.git"

  bottle do
    cellar :any
    sha256 "fa747d84f30a2b26a521cbed69560cb2d9fc3dd7065dbc51c274d08a45c7a5f4" => :el_capitan
    sha256 "ad73376dfce7109311af0d82b1b1c3a099df83e1deae5152fd5f739dea064144" => :yosemite
    sha256 "71de274749145c379780e6941aaa30f1aec0ac4254156b25e7b32dde5d969d0b" => :mavericks
  end

  devel do
    url "https://github.com/matplotlib/matplotlib/archive/v2.0.0b4.tar.gz"
    sha256 "8648dce20b53271720d8c5c439c23c11c220561119242c7fcd14ea10ca2ef3f9"
    version "2.0.0b4"
  end

  option "without-python", "Build without python2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  requires_py2 = []
  requires_py2 << "with-python" if build.with? "python"
  requires_py3 = []
  requires_py3 << "with-python3" if build.with? "python3"

  option "with-cairo", "Build with cairo backend support"
  option "with-pygtk", "Build with pygtk backend support (python2 only)"
  deprecated_option "with-gtk3" => "with-gtk+3"

  depends_on NoExternalPyCXXPackage => :build
  depends_on "pkg-config" => :build

  depends_on "freetype"
  depends_on "libpng"
  depends_on "homebrew/python/numpy" => requires_py3
  depends_on "ghostscript" => :optional
  depends_on "homebrew/dupes/tcl-tk" => :optional

  if build.with? "cairo"
    depends_on "py2cairo" if build.with? "python"
    depends_on "py3cairo" if build.with? "python3"
  end

  depends_on "gtk+3" => :optional
  depends_on "pygobject3" => requires_py3 if build.with? "gtk+3"

  depends_on "pygtk" => :optional
  depends_on "pygobject" if build.with? "pygtk"

  depends_on "pyqt5" => [:optional] + requires_py2

  depends_on :tex => :optional
  depends_on DvipngRequirement if build.with? "tex"

  cxxstdlib_check :skip

  resource "setuptools" do
    url "https://pypi.python.org/packages/cd/1b/2aaf7aef152a274c687e0441a75f3df5fa1de0144cf3fba856d916558c20/setuptools-28.6.0.tar.gz"
    sha256 "4fdaf635f2ea815f914d94cfe2f7f856b5d46697defa68fcfb335870707bc2d9"
  end

  resource "Cycler" do
    url "https://pypi.python.org/packages/source/C/Cycler/cycler-0.10.0.tar.gz"
    sha256 "cd7b2d1018258d7247a71425e9f26463dfb444d411c39569972f4ce586b0c9d8"
  end

  resource "funcsigs" do
    url "https://pypi.python.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "nose" do
    url "https://pypi.python.org/packages/source/n/nose/nose-1.3.7.tar.gz"
    sha256 "f1bffef9cbc82628f6e7d7b40d7e255aefaa1adb6a1b1d26c69a8b79e6208a98"
  end

  resource "mock" do
    url "https://pypi.python.org/packages/source/m/mock/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "pbr" do
    url "https://pypi.python.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pyparsing" do
    url "https://pypi.python.org/packages/38/bb/bf325351dd8ab6eb3c3b7c07c3978f38b2103e2ab48d59726916907cd6fb/pyparsing-2.1.10.tar.gz"
    sha256 "811c3e7b0031021137fc83e051795025fcb98674d07eb8fe922ba4de53d39188"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/62/de/3ec428a9a656c4568f8a01b93bda4aff43c3fadfa50356048a62de9ee3b7/pytz-2016.7.tar.gz"
    sha256 "8787de03f35f31699bcaf127e56ad14c00647965ed24d72dbaca87c6e4f843a3"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    inreplace "setupext.py",
              "'darwin': ['/usr/local/'",
              "'darwin': ['#{HOMEBREW_PREFIX}'"

    # Apple has the Frameworks (esp. Tk.Framework) in a different place
    unless MacOS::CLT.installed?
      inreplace "setupext.py",
                "'/System/Library/Frameworks/',",
                "'#{MacOS.sdk_path}/System/Library/Frameworks',"
    end

    Language::Python.each_python(build) do |python, version|
      bundle_path = libexec/"lib/python#{version}/site-packages"
      bundle_path.mkpath
      ENV.prepend_path "PYTHONPATH", bundle_path
      resources.each do |r|
        r.stage do
          system python, *Language::Python.setup_install_args(libexec)
        end
      end
      (lib/"python#{version}/site-packages/homebrew-matplotlib-bundle.pth").write "#{bundle_path}\n"

      system python, *Language::Python.setup_install_args(prefix)
    end
  end

  def caveats
    s = <<-EOS.undent
      If you want to use the `wxagg` backend, do `brew install wxpython`.
      This can be done even after the matplotlib install.
    EOS
    if build.with?("python") && !Formula["python"].installed?
      homebrew_site_packages = Language::Python.homebrew_site_packages
      user_site_packages = Language::Python.user_site_packages "python"
      s += <<-EOS.undent
        If you use system python (that comes - depending on the OS X version -
        with older versions of numpy, scipy and matplotlib), you may need to
        ensure that the brewed packages come earlier in Python's sys.path with:
          mkdir -p #{user_site_packages}
          echo 'import sys; sys.path.insert(1, "#{homebrew_site_packages}")' >> #{user_site_packages}/homebrew.pth
      EOS
    end
    s
  end

  test do
    ENV["PYTHONDONTWRITEBYTECODE"] = "1"

    ohai "This test takes quite a while. Use --verbose to see progress."
    Language::Python.each_python(build) do |python, _|
      system python, "-c", "import matplotlib as m; m.test()"
    end
  end
end
