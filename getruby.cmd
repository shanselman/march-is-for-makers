@ECHO ON

REM Put Ruby in Path
REM You can also use %TEMP% but it is cleared on site restart. Tools is persistent.
SET PATH=%PATH%;D:\home\site\deployments\tools\r\ruby-2.1.5-x64-mingw32\bin

REM I am in the repository folder
pushd D:\home\site\deployments\tools 
if not exist r md r
cd r 
if exist ruby-2.1.5-x64-mingw32 goto end

echo No Ruby, need to get it!

REM Get Ruby and Rails
REM 32bit
REM curl -o rubyrails193.zip http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.1.5-i386-mingw32.7z?direct
REM 64bit
curl -o ruby215.zip http://dl.bintray.com/oneclick/rubyinstaller/ruby-2.1.5-x64-mingw32.7z?direct
REM Azure puts 7zip here!
EcHO START Unzipping Ruby
d:\7zip\7za x -xr!*.ri -y ruby215.zip > rubyout
EcHO DONE Unzipping Ruby

REM Get DevKit to build Ruby native gems  
REM If you don't need DevKit, rem this out.
curl -o DevKit.zip http://cdn.rubyinstaller.org/archives/devkits/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe
EcHO START Unzipping DevKit
d:\7zip\7za x -y -oDevKit DevKit.zip > devkitout
EcHO DONE Unzipping DevKit

REM Init DevKit
ruby DevKit\dk.rb init

REM Tell DevKit where Ruby is
echo --- > config.yml
echo - D:/home/site/deployments/tools/r/ruby-2.1.5-x64-mingw32 >> config.yml

REM Setup DevKit
ruby DevKit\dk.rb install

REM Update Gem223 until someone fixes the Ruby Windows installer https://github.com/oneclick/rubyinstaller/issues/261
curl -L -o update.gem https://github.com/rubygems/rubygems/releases/download/v2.2.3/rubygems-update-2.2.3.gem
call gem install --local update.gem
call update_rubygems --no-ri --no-rdoc > updaterubygemsout
ECHO What's our new Rubygems version?
call gem --version
call gem uninstall rubygems-update -x

REM Why is this needed on Windows? 
ECHO Install eventmachine 1.0.7
call gem install eventmachine -v '1.0.7' --no-ri --no-rdoc > updateventmachineout

ECHO Before :end
cd
:end
ECHO After :end
cd
REM Need to be in Reposistory
popd
ECHO Update Bundler
call bundle update

REM get middleman
ECHO Install middleman...the whole point!
REM call gem install middleman --no-ri --no-rdoc

call middleman build
REM KuduSync is after this!
