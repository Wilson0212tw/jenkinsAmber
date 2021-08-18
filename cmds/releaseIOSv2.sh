#$1:包名 $2:環境名(stg, prd) $3: bundleId $4 :envVer

#步驟1: 先檢查上版暫存資料夾是否存在


if [ -d "../../tempReleaseFolder" ]
then
    rm -rf ../../tempReleaseFolder
    mkdir ../../tempReleaseFolder
else
    mkdir ../../tempReleaseFolder
fi
#步驟2: 將ipa檔複製過來暫存資料夾
cp ../../app/build/Runner.ipa ../../tempReleaseFolder/$1.ipa

# https://www.dropbox.com/s/8l7ruj7d30y1wij/BM_test_NEW.ipa?dl=0
# https://www.dropbox.com/s/umdzy9zk91ei59d/BM_test_NEW2.ipa?dl=0
# https://www.dropbox.com/s/dsmzclpfu88gepu/BM_PRD_NEW.ipa?dl=0

# https://www.dropbox.com/s/2loj8bmorcu0sow/BM_test_NEW.plist?dl=0
# https://www.dropbox.com/s/9axp60nequqxwaq/BM_test_NEW2.plist?dl=0
# https://www.dropbox.com/s/ol5kx1fmf5b0fvh/BM_PRD_NEW.plist?dl=0


ipaLinkPath=''
plistLinkPath=''
fileName=''
qrCodeFileName=""

if [ $2  ==  stg ] ; then
       if [ $4  ==  1  ] ; then
           ipaLinkPath="8l7ruj7d30y1wij"
           plistLinkPath="2loj8bmorcu0sow"
           fileName="BM_test_NEW"
           qrCodeFileName="test_stg"
       else
            ipaLinkPath="umdzy9zk91ei59d"
            plistLinkPath="9axp60nequqxwaq"
            fileName="BM_test_NEW2"
            qrCodeFileName="test_stg2"
       fi
else
          ipaLinkPath="dsmzclpfu88gepu"
        plistLinkPath="ol5kx1fmf5b0fvh"
          fileName="BM_PRD_NEW"
          qrCodeFileName="prd"
fi



#步驟3: 製作plist檔，放進暫存資料夾
echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>items</key>
        <array>
                <dict>
                        <key>assets</key>
                        <array>
                                <dict>
                                        <key>kind</key>
                                        <string>software-package</string>
                                        <key>url</key>
                                        <string>https://dl.dropboxusercontent.com/s/$ipaLinkPath/$fileName.ipa</string>
                                </dict>
                        </array>
                        <key>metadata</key>
                        <dict>
                                <key>bundle-identifier</key>
                                <string>$3</string>
                                <key>title</key>
                                <string>$1</string>
                                <key>kind</key>
                                <string>software</string>
                                <key>bundle-version</key>
                                <string>1.0</string>
                        </dict>
                </dict>
        </array>
</dict>
</plist>" > ../../tempReleaseFolder/$fileName.plist


#步驟4: 將下載頁拉下來，放進暫存資料夾
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 TW_RD@10.6.1.100:/home/img-server/bm-$2-iOS.html ../../tempReleaseFolder/

#步驟5: 插入下載鏈結
sed -ie '1i\
    <H1><a href="itms-services://?action=download-manifest&amp;url=https://dl.dropboxusercontent.com/s/'$plistLinkPath'/'$fileName'.plist">'$1'</a></H1>\
     <img src="/bmImg/'$qrCodeFileName'.jpeg" style="width:300px">\
     <H2>==============================================================</H2>
     ' ../../tempReleaseFolder/bm-$2-iOS.html





#步驟6: 上傳ipa, plist
    cp ../../tempReleaseFolder/$1.ipa $HOME/Dropbox/$fileName.ipa
    cp ../../tempReleaseFolder/$fileName.plist $HOME/Dropbox/$fileName.plist


#步驟7: 上傳html
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 ../../tempReleaseFolder/bm-$2-iOS.html TW_RD@10.6.1.100:/home/img-server/