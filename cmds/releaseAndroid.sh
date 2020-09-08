#$1:包名 $2:環境名(stg, prd)

#步驟1: 先檢查上版暫存資料夾是否存在
if [ -d "../../tempReleaseFolder" ]
then
    rm -rf ../../tempReleaseFolder
    mkdir ../../tempReleaseFolder
else
    mkdir ../../tempReleaseFolder
fi

#步驟2: 將apk檔複製過來暫存資料夾
cp ../../app/build/Runner.apk ../../tempReleaseFolder/$1.apk

#步驟3: 將下載頁拉下來，放進暫存資料夾
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 TW_RD@10.6.1.100:/home/img-server/bm-$2-android.html ../../tempReleaseFolder/

#步驟4: 插入下載鏈結
sed -ie '1i\
<H1><a href="https://dl.phl5b.org/apks/bm_'$2'/'$1'.apk">'$1'</a></H1>
' ../../tempReleaseFolder/bm-$2-android.html

#步驟5: 上傳apk
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 ../../tempReleaseFolder/$1.apk TW_RD@10.6.1.100:/home/img-server/apks/bm_$2/

#步驟6: 上傳html
sshpass -p "27ZrKw^h2e2rFnph" scp -P 22897 ../../tempReleaseFolder/bm-$2-android.html TW_RD@10.6.1.100:/home/img-server/