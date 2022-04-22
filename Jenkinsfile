pipeline {
    agent any

    environment {
        project = "${projectName}"
    }

    stages {
        stage('build') {
            steps {
                sh 'cd /home'
            }
            steps {
                git credentialsId: 'aaf5a85a-17a0-4328-892e-48163fbfcaf9', url: 'http://192.168.1.12:9091/root/test-api.git'
            }
            steps {
                sh "tar -zcf ${project}.tar.gz ${project} --exclude=${project}/.git --exclude=${project}/README.md"
            }
        }
        stage('publish') {
            steps{
            	sh "version=`date +%Y%m%d%H%I%S`"
                sh "scp ${project}.tar.gz root@192.168.1.12:/home/wwwroot/version/"
                sh "ssh -p 22 root@192.168.1.12 'cd /home/wwwroot/version/ && tar zxvf ${project}-${version}.tar.gz && rm -f ${project}-${version}.tar.gz && mv /home/wwwroot/version/${project} /home/wwwroot/version/${project}-${version}&& ln -snf /home/wwwroot/version/${project} /home/wwwroot/${project}'"
            }
        }
    }
}
