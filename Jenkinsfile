def volumes = [ hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock') ]
volumes += secretVolume(secretName: 'jenkins-docker-sec', mountPath: '/jenkins_docker_sec')
podTemplate(label: 'icp-liberty-build',
            nodeSelector: 'beta.kubernetes.io/arch=s390x',
    containers: [
        containerTemplate(name: 'jnlp', image: 'dc1cp01.icp:8500/default/jnlp-z:3.20-june2018.1', ttyEnabled: true),
        containerTemplate(name: 'maven', image: 'dc1cp01.icp:8500/default/maven-z:3.5.4-jdk-8-june2018.1', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'docker', image: 'dc1cp01.icp:8500/default/docker-z:17.12-june2018.1', ttyEnabled: true, command: 'cat')
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
         stage ('docker') {
          container('docker') {
            def imageTag = "dc1cp01.icp:8500/jenkinstest/jenkinstest:${gitCommit}"
            echo "imageTag ${imageTag}"
            sh """
            ln -s /jenkins_docker_sec/.dockercfg /home/jenkins/.dockercfg
            mkdir /home/jenkins/.docker
            ln -s /jenkins_docker_sec/.dockerconfigjson /home/jenkins/.docker/config.json
            docker build -t jenkinstest .
            docker tag jenkinstest $imageTag
            docker push $imageTag
            """
          }
        }
    }
}
