push .
md temp2
cd temp2

if exist ruby-1.9.3-p551-i386-mingw32\bin\ruby.exe (
  echo Ruby is here!
) else (

  REM Get 7Zip
  curl -o 7zip.zip http://netcologne.dl.sourceforge.net/project/sevenzip/7-Zip/9.20/7za920.zip
  unzip 7zip.zip

  REM Get Ruby and Rails
  REM 32bit
  REM curl -o rubyrails193.zip http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.1.5-i386-mingw32.7z?direct
  REM 64bit
  curl -o rubyrails215.zip http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.1.5-x64-mingw32.7z?direct
  7za x rubyrails215.zip

  REM Put Ruby in Path
  REM D:\home is for all Azure websites! Maybe change to %~dp0%?
  SET PATH=%PATH%;%~dp0%temp2\ruby-2.1.5-x64-mingw32\bin
  
  REM Get DevKit to build Ruby native gems  
  curl -o DevKit.zip http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe
  7za -oDevKit x DevKit.zip

  REM Init DevKit
  ruby DevKit\dk.rb init

  REM Tell DevKit where Ruby is
  echo --- > config.yml
  echo - %~dp0%temp2/ruby-2.1.5-x64-mingw32 >> config.yml
  
  REM Setup DevKit
  ruby DevKit\dk.rb install
  
  REM Update Gem223 until someone fixes the Ruby Windows installer
  curl -L o update.gem https://github.com/rubygems/rubygems/releases/download/v2.2.3/rubygems-update-2.2.3.gem
  call gem install --local update.gem
  update_rubygems --no-ri --no-rdoc
  call gem --version
  call gem uninstall rubygems-update -x
  
  REM get middleman
  call gem install middleman

)
popd
