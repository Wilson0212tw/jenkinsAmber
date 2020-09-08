// Git Repo Url
def gitRepoUrl = 'http://git.bomao.com/appv3/app.git'
//分支名稱
def envName = ''
// 使用的認證id
def credentialsId = '81c526c9-6509-42e1-ae3d-c49cf6ac2214'
// 專案資料夾名稱
def projectName = 'app'
// // 包名後綴時間
// def now = new Date()
// now = now.format("MMddHHmm")
// def packageName = params.包名 + '_' + now
// 包名
def packageName = params.包名
// 環境名稱字串
def envStg = ''
// 下載連結
def downloadUrl = ''
// iOS用bundleID
def bundleId = ''

//腳本資料夾名稱
def cmdsFolderName = 'cmds'
//腳本所在Repo
def cmdsRepoUrl = 'https://github.com/Wilson0212tw/jenkinsAmber.git'
//Repo 認證資料
def cmdsCredentialsId = 'ae5539dc-8fb3-463b-9a9d-71b14a91577a'
//腳本Repo 分支名稱
def cmdsEnvName = 'master'

pipeline {
    agent any
    stages {
        stage('check out cmds repo') {
            steps {
                dir(cmdsFolderName) {
                    git (
                        url: cmdsRepoUrl,
                        credentialsId: cmdsCredentialsId,
                        branch: cmdsEnvName
                    )
                }
            }
        }
        stage('check out env repo') {
            steps {
                script {
                    switch (params.環境) {
                        case 'stg':
                            envName = 'stg'
                            break
                        case 'prd':
                            envName = 'prd'
                            break
                        default:
                            break
                    }   
                }
                dir(projectName) {
                    git (
                        url: gitRepoUrl,
                        credentialsId: credentialsId,
                        branch: envName
                    )
                }
            }
        }
        stage('build') {
            steps {
                dir(projectName) {
                    script {
                        switch (params.平台) {
                            case 'ios':
                                sh 'make build-ios;make release-ios'
                                break;
                            case 'android':
                                sh 'make build-android'
                                break;
                            case 'both':
                                sh 'make build-ios;make release-ios;make build-android'
                                break;
                        }
                    }
                }
            }
        }
        stage('release'){
            steps {
                script {
                    switch(params.環境) {
                        case 'stg':
                            envStg = 'stg'
                            downloadUrl = 'http://dl.phl5b.org/bm-install.html?env=stg'
                            bundleId = 'com.ibmao88.bocatappStg'
                            break
                        case 'prd':
                            envStg = 'prd'
                            downloadUrl = 'http://dl.phl5b.org/bm-install.html?env=prd'
                            bundleId = 'com.ibmao88.bocatapp'
                            break
                        default:
                            break
                    }
                }
                
                script {
                    switch(params.平台) {
                        case 'ios':
                            dir('cmds/cmds') {
                                def cmd = 'sh releaseIOS.sh ' + packageName + ' ' + envStg + ' ' + bundleId
                                sh cmd
                                sh 'sh cleanBuildAndReleaseFolder.sh'
                            }   
                            sendTelegram(getReleaseText(envStg, 'ios', packageName, params.更新項目, downloadUrl))
                            break
                        case 'android':
                            dir('cmds/cmds') {
                                def cmd = 'sh releaseAndroid.sh ' + packageName + ' ' + envStg
                                sh cmd
                                sh 'sh cleanBuildAndReleaseFolder.sh'
                            }   
                            sendTelegram(getReleaseText(envStg, 'android', packageName, params.更新項目, downloadUrl))
                            break
                        case 'both':
                            dir('cmds/cmds') {
                                def cmd1 = 'sh releaseIOS.sh ' + packageName + ' ' + envStg + ' ' + bundleId
                                sh cmd1
                                def cmd2 = 'sh releaseAndroid.sh ' + packageName + ' ' + envStg
                                sh cmd2
                                sh 'sh cleanBuildAndReleaseFolder.sh'
                            }
                            sendTelegram(getReleaseText(envStg, 'ios, android', packageName, params.更新項目, downloadUrl))
                            break
                    }
                }
            }
        }
    }
}

def getReleaseText(env, platform, packageName, reason, downloadUrl) {
    return 'BM Flutter 在 ' + env + ' 有新版本发布!\n\n发布平台：\n' + platform + '\n\n包名：\n' + packageName + '\n\n更新项目：\n' + reason + '\n\n下载链结：\n' + downloadUrl
}

def sendTelegram(message) {
    def encodedMessage = URLEncoder.encode(message, "UTF-8")

    withCredentials([string(credentialsId: 'tgArchiveBotId', variable: 'TOKEN'),
    string(credentialsId: 'tgBmFlutterArchiveChatId', variable: 'CHAT_ID')]) {
        response = httpRequest (consoleLogResponseBody: true,
                contentType: 'APPLICATION_JSON',
                httpMode: 'GET',
                url: "https://api.telegram.org/bot$TOKEN/sendMessage?text=$encodedMessage&chat_id=$CHAT_ID&disable_web_page_preview=true",
                validResponseCodes: '200')
        return response
    }
}