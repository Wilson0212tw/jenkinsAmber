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


#步驟4: 將下載頁拉下來，放進暫存資料夾
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 TW_RD@10.6.1.100:/home/img-server/bm-$2-iOS.html ../../tempReleaseFolder/

#步驟5: 插入下載鏈結
#步驟5: 插入下載鏈結

echo $2
echo $4
echo  '-----param done--------' 

if [ "$2" == "stg" ] ; then
       if [ "$4" == "1" ] ; then
               sed -ie '1i\
               <H1><a href="itms-services://?action=download-manifest&amp;url=https://dl.dropboxusercontent.com/s/2loj8bmorcu0sow/BM_test_NEW.plist">'$1'</a></H1>
              <img src="/bmImg/test_stg.jpeg" style="width:300px">
               <H2>==============================================================</H2>
               ' ../../tempReleaseFolder/bm-$2-iOS.html
       else
             sed -ie '1i\
             <H1><a href="itms-services://?action=download-manifest&amp;url=https://dl.dropboxusercontent.com/s/9axp60nequqxwaq/BM_test_NEW2.plist">'$1'</a></H1>
            <img src="/bmImg/test_stg2.jpeg" style="width:300px">
            <H2>==============================================================</H2>
            ' ../../tempReleaseFolder/bm-$2-iOS.html
       fi
else
    sed -ie '1i\
    <H1><a href="itms-services://?action=download-manifest&amp;url=https://dl.dropboxusercontent.com/s/batx00ehph50r5j/BM_PRD_NEW.plist">'$1'</a></H1>
    ' ../../tempReleaseFolder/bm-$2-iOS.html
fi



#步驟6: 上傳ipa, plist

if [ "$2" == "stg" ];  then
     if [ "$4" == "1" ] ;  then 
               cp ../../tempReleaseFolder/$1.ipa $HOME/Dropbox/BM_test_NEW.ipa
     else 
               cp ../../tempReleaseFolder/$1.ipa $HOME/Dropbox/BM_test_NEW2.ipa
    fi
else
     cp ../../tempReleaseFolder/$1.ipa $HOME/Dropbox/BM_PRD_NEW.ipa
fi
#步驟7: 上傳html
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 ../../tempReleaseFolder/bm-$2-iOS.html TW_RD@10.6.1.100:/home/img-server/