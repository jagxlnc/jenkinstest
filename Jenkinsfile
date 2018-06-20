def volumes = [ hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock') ]
podTemplate(label: 'icp-liberty-build',
    containers: [
        containerTemplate(name: 'maven', image: 'maven:3.5.2-jdk-8', ttyEnabled: true, command: 'cat'),
    ],
    volumes: volumes
)
{
    node ('icp-liberty-build') {
        def gitCommit
        stage ('Extract') {
          checkout scm
          gitCommit = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
          echo "checked out git commit ${gitCommit}"
        }
        stage ('maven build') {
          container('maven') {
            sh '''
            mvn clean test install
            '''
          }
        }
    }
}
