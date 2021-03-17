#$1:包名 $2:環境名(stg, prd) $3: bundleId

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
					<string>https://dl.phl5b.org/iOS/bm_$2/$1.ipa</string>
				</dict>
			</array>
			<key>metadata</key>
			<dict>
				<key>title</key>
				<string>$1</string>
				<key>bundle-version</key>
				<string>1.0</string>
				<key>kind</key>
				<string>software</string>
				<key>bundle-identifier</key>
				<string>$3</string>
			</dict>
		</dict>
	</array>
</dict>
</plist>" > ../../tempReleaseFolder/$1.plist



#步驟4: 將下載頁拉下來，放進暫存資料夾
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 TW_RD@10.6.1.100:/home/img-server/bm-$2-iOS.html ../../tempReleaseFolder/

#步驟5: 插入下載鏈結
#步驟5: 插入下載鏈結
sed -ie '1i\
<H1><a href="itms-services://?action=download-manifest&amp;url=https://dl.phl5b.org/iOS/bm_'$2'/'$1'.plist">'$1'</a></H1>
' ../../tempReleaseFolder/bm-$2-iOS.html

if [ '$2' = "stg" ]
then
   sed -ie '1i\
<H1><a href="itms-services://?action=download-manifest&amp;url=https://dl.dropboxusercontent.com/s/2loj8bmorcu0sow/BM_test_NEW.plist">'$1'</a></H1>
' ../../tempReleaseFolder/bm-$2-iOS.html
else
    sed -ie '1i\
<H1><a href="itms-services://?action=download-manifest&amp;url=https://dl.dropboxusercontent.com/s/batx00ehph50r5j/BM_PRD_NEW.plist">'$1'</a></H1>
' ../../tempReleaseFolder/bm-$2-iOS.html
fi



#步驟6: 上傳ipa, plist
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 ../../tempReleaseFolder/$1.ipa TW_RD@10.6.1.100:/home/img-server/iOS/bm_$2/
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 ../../tempReleaseFolder/$1.plist TW_RD@10.6.1.100:/home/img-server/iOS/bm_$2/
if [ '$2' = "stg" ]
then
cp ../../tempReleaseFolder/$1.ipa $HOME/Dropbox/BM_test_NEW.ipa
else
cp ../../tempReleaseFolder/$1.ipa $HOME/Dropbox/BM_PRD_NEW.ipa
fi
#步驟7: 上傳html
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 ../../tempReleaseFolder/bm-$2-iOS.html TW_RD@10.6.1.100:/home/img-server/