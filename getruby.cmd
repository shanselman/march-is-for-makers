@ECHO ON
REM I am in the repository folder
pushd %temp% 
if not exist temp2 md temp2
cd temp2 
if exist ruby-2.1.5-x64-mingw32 goto end

echo No Ruby, need to get it!

REM Get Ruby and Rails
REM 32bit
REM curl -o rubyrails193.zip http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.1.5-i386-mingw32.7z?direct
REM 64bit
curl -o rubyrails215.zip http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.1.5-x64-mingw32.7z?direct
REM Azure puts 7zip here!
d:\7zip\7za x rubyrails215.zip

REM Put Ruby in Path
SET PATH=%PATH%;%temp%\temp2\ruby-2.1.5-x64-mingw32\bin

REM Get DevKit to build Ruby native gems  
curl -o DevKit.zip http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe
d:\7zip\7za -oDevKit x DevKit.zip

REM Init DevKit
ruby DevKit\dk.rb init

REM Tell DevKit where Ruby is
echo --- > config.yml
echo - %temp%/temp2/ruby-2.1.5-x64-mingw32 >> config.yml

REM Setup DevKit
ruby DevKit\dk.rb install

REM Update Gem223 until someone fixes the Ruby Windows installer
curl -L o update.gem https://github.com/rubygems/rubygems/releases/download/v2.2.3/rubygems-update-2.2.3.gem
call gem install --local update.gem
update_rubygems --no-ri --no-rdoc
call gem --version
call gem uninstall rubygems-update -x

REM get middleman
call gem install middleman --no-ri --no-rdoc


:end
popd
REM I am back in repository
middleman build
REM KuduSync is after this!
