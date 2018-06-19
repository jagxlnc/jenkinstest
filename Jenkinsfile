def volumes = [ hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock') ]
volumes += secretVolume(secretName: 'microclimate-registry-secret', mountPath: '/msb_reg_sec')
volumes += secretVolume(secretName: 'microclimate-helm-secret', mountPath: '/msb_helm_sec')
volumes += persistentVolumeClaim(mountPath: '/root/.m2', claimName: 'maven-repo', readOnly: false)
podTemplate(label: 'icp-liberty-build',
    containers: [
        containerTemplate(name: 'maven', image: 'maven:3.5.2-jdk-8', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'docker', image: 'ibmcom/docker:17.10', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'kubectl', image: 'ibmcom/k8s-kubectl:v1.8.3', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'helm', image: 'lachlanevenson/k8s-helm:v2.7.2', ttyEnabled: true, command: 'cat')
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
          sh """
          mkdir ~/.ssh
          echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAyNS8ElKci7pu1tSRMejnwBfAUjpvUS0N3CuiSn69mhSzY/9p
gUGEnmhfjfrJpS4hRZEZldzoZJurY0hJgcs/O54uJC1GUbreQJyERv0pZL/P7PrQ
Q25RyG1jAEeZYQU6jHvBEtK4Vuwnp4Turc4yJp2NT+EECEQj1WFgABq4weLmn/OV
+ndEFxf1IIv0/e6lPDv9WTiJcX5+EFpobV0tYNvFzZ1nZ8G86MAQ9NJB+T4PdC89
o4lIW3v+OmLd9kBaFsqVAkX02zVOa6ctbvJQSFAmWHd9L5AsmHbfddNwsMbd3bfZ
OuGgh+4rRwURmzh0HpABz7YUXnIvt2QUthi9hwIDAQABAoIBAQCYp9wtsU39iEEo
W3vijD9c7LDr0C89bRnT+fbq2VwV+xZBNKxl6/96yauYqMEOJfp0fs8L81dS4mFs
nk4BsxTlpF8+cIu7JGg8hLynmVgVlRff8ubL2tefmkZeuA4GiYrvrkIcpMAqkmey
FoG2672DTM9VoJ0IC4ORdusaKTW3agEyxFvGYfwsUS+s01AOpBwZSDXTmNndEgrr
6fewO7/xAr56LVYUJGLH2SQfYi0aZRVPlpkGG2Cqzk85li3RVQ9Sm1/6yoB4JLzl
aikbnOeCPhOuITCADv7eAWg3sduot4T3PGqndxQBQBjcKqQrebhT0n22bPtzaKxe
cIi53L3BAoGBAOn6nD0XpIAN3e8ZFTTATChOArQUAriEuVA7ooBXThGYeX63jcIe
BQxXKzjoRVYAHgG3+wbGmwqKt6xiIWD1mhDjzOZbttWAbgy5rfPLcNUUbIivpaOx
tWMISHEGyVZPynA09kwxc4mO1S7QrmROCgU7niYctOyEwwYNbDyDQLIbAoGBANu7
eLywrdWud2xdiRpDsqFzZvcmy27imH24fayrRnwKeh/2zAQqULysvF9ie1gdC5Tt
Gzcq7+7uqPhjGhtTGqClBRGn8bDK8b1jVR3RWucfzFEBot3NSMP8y8X+wP1sW4fa
fl2IiYjEdD4N0NEefWNt2GcFS6PB+6GCBh1LW/kFAoGACJm+rnw0/sQDuWs5nVPI
ON8NOGNX6kJusWVPxtnus7TgGmlS26TQ2LBHlXLsQYoFkFib8JbSUiPhNoPw6Ch+
/knxWTJb2SM8aFlW7JQ41IxIpQmX1BmPKlG+n/D466RJM7CusQRMU+0dJvhiwKsh
sSmM2afKersylAFgTiUg9qsCgYA3Y2Jj7gVjv77KyiktPbNhjz19P4I4SVY3GrJT
PDlgOyPdutBinGgNp100jhaZd3jb6YjatzAUAoUFV7XU/XXQ2MgWU0dRUVbuboOe
KI/JgvJ12Pu8/WpCPQ8Asd7kAtRvwlvoJ+rDVwIWQlVI4W6qCZ5rGaKffN55L9Vq
vPxKIQKBgQC/guvuJL0sQqQcKdgdmZinJtQP93WGRRGWzmfFAC4wR2lj50vdNwZ5
1FHtMuxAhMDOqV9Yyl/MSnu5XeMBhqVTX0lpBmdaIZX2fzUEej4vnB263hTE534h
3GDGH1S8OizBlbb7XLPhvvwHgD4z7rq/peXobbxiEYfggH5d+EKviQ==
-----END RSA PRIVATE KEY-----" >> ~/.ssh/id_rsa
          cat ~/.ssh/id_rsa
          ssh -v -o StrictHostKeyChecking=no root@9.37.138.189
          """
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
            def imageTag = "mycluster.icp:8500/jenkinstest/jenkinstest:${gitCommit}"
            echo "imageTag ${imageTag}"
            sh """
            docker build -t jenkinstest .
            docker tag jenkinstest $imageTag
            ln -s /msb_reg_sec/.dockercfg /home/jenkins/.dockercfg
            mkdir /home/jenkins/.docker
            ln -s /msb_reg_sec/.dockerconfigjson /home/jenkins/.docker/config.json
            docker push $imageTag
            """
          }
        }
        stage ('deploy') {
          container('kubectl') {
            def imageTag = null
            imageTag = gitCommit
            sh """
            #!/bin/bash
            echo "checking if jenkinstest-deployment already exists"
            if kubectl describe deployment jenkinstest-deployment --namespace jenkinstest; then
                echo "Application already exists, update..."
                kubectl set image deployment/jenkinstest-deployment jenkinstest=mycluster.icp:8500/jenkinstest/jenkinstest:${imageTag} --namespace jenkinstest
            else
                sed -i "s/<DOCKER_IMAGE>/jenkinstest:${imageTag}/g" manifests/kube.deploy.yml
                echo "Create deployment"
                kubectl apply -f manifests/kube.deploy.yml --namespace jenkinstest
                echo "Create service"
            fi
            echo "Describe deployment"
            kubectl describe deployment jenkinstest-deployment --namespace jenkinstest
            echo "finished"
            """
          }
        }
    }
}
