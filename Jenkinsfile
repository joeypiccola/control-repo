def BRANCH = EVENT_BRANCH.split('/')[1]

pipeline {
	agent any
    options {
        timeout(time: 1, unit: 'HOURS')
    }
    parameters {
        string(name: 'EVENT_BRANCH')
    }
	stages {
        stage('setup') {
            parallel {
                stage('job') {
                    steps {
                        // hipchatSend color: 'GRAY', failOnError: true, message: "[#${BUILD_NUMBER}] ${BRANCH} started.", textFormat: true, room: hipChatRoom, token: hipChatToken
                        script {
                            currentBuild.description = "\"${BRANCH}\" test and deployment"
                        }
                    }
                }
                stage('token') {
                    steps {
                        script {
                            puppet.credentials 'dc0758a9-9f9b-48cd-84ab-e86c6884d93d'
                        }
                    }
                }
                stage('env') {
                    steps {
                        powershell '''
                           cmd /c set
                        '''
                    }
                }
            }
        }
        stage('pdk tests') {
            failFast false
            parallel {
                stage('puppet') {
                    steps {
                        powershell '''
                            .\\build\\Invoke-PDKValidate.ps1 -test puppet
                        '''
                    }
                }
                stage('ruby') {
                    steps {
                        powershell '''
                            .\\build\\Invoke-PDKValidate.ps1 -test ruby
                        '''
                    }
                }
            }
        }
        stage('powershell tests') {
            failFast false
            parallel {
                stage('parse') {
                    steps {
                        powershell '''
                            .\\build\\Invoke-PowerShellParse.ps1
                        '''
                    }
                }
                stage('PSSA default') {
                    steps {
                        powershell '''
                            .\\build\\Invoke-PSScriptAnalyzer.ps1 -test default
                        '''
                    }
                }
                stage('PSSA OTBS') {
                    steps {
                        powershell '''
                            .\\build\\Invoke-PSScriptAnalyzer.ps1 -test CodeFormattingOTBS
                        '''
                    }
                }
            }
        }
        stage('yaml tests') {
            failFast false
            parallel {
                stage('parse') {
                    steps {
                        powershell '''
                            .\\build\\Invoke-YAMLParse.ps1
                        '''
                    }
                }
            }
        }
        stage('deploy') {
            steps{
                script {
                    puppet.codeDeploy BRANCH
                }
            }
        }
        stage('run') {
            parallel {
                stage('development') {
                    // when development and nodes are in development then run a job
                    when {
                        allOf {
                            expression {
                                BRANCH == 'development'
                            }
                            expression {
                                puppet.query "nodes { catalog_environment = 'development' }"
                            }
                        }
                    }
                    steps {
                        script {
                            puppet.job 'development', query: 'nodes { catalog_environment = "development" }'
                        }
                    }
                }
                stage('feature') {
                    // when not production or development and nodes are in feature then run a job
                    when {
                        allOf {
                            expression {
                                BRANCH != 'production' && BRANCH != 'development'
                            }
                            expression {
                                puppet.query "nodes { catalog_environment = \"${BRANCH}\" }"
                            }
                        }
                    }
                    steps {
                        script {
                            String QUERY = "nodes { catalog_environment = \"${BRANCH}\" }"
                            puppet.job BRANCH, query: QUERY
                        }
                    }
                }
            }
        }
    }
    // post {
    //     success {
    //         hipchatSend color: 'GREEN', failOnError: true, message: "[#${BUILD_NUMBER}] ${BRANCH} succeeded.", textFormat: true, room: hipChatRoom, token: hipChatToken
    //     }
    //     aborted {
    //         hipchatSend color: 'YELLOW', failOnError: true, message: "[#${BUILD_NUMBER}] ${BRANCH} aborted.", textFormat: true, room: hipChatRoom, token: hipChatToken
    //     }
    //     failure {
    //         hipchatSend color: 'RED', failOnError: true, message: "[#${BUILD_NUMBER}] ${BRANCH} failed.", textFormat: true, room: hipChatRoom, token: hipChatToken
    //     }
    // }
}