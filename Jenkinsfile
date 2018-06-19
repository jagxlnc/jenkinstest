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
          echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/29T+1c3uhdIjzYHc581oJ0BTxuAbKU+3pVQBisbFnFBr4+5DPV4ExXvL2KMb/1+usdihH8HoVkDDmaYCXlbmooy/kQudgxcEQeDmVCow61dhR8T0zIdd9wPfJULtAtL4mFwT36rW7SfqbP4F12l9uwQisE9DKye5hVMwcK4EootPmzYh4SaGLNv+QmM8ZxcroudXNRDooDiBfiHMXGF5EnWOulUb7eYTEP1qJMFHSoWvv0YCky5xWvL226FFif/4H9jKgO6UE5FAyx/SxYdg2e+rnfjmLkt6CybrduDgNISHAfPGTvzkaAN1T0fN8X1EAmuXK0GGyIMICfOCB3aLNfWGfON5IDosIFLPQVAm46F5IsZmyLFuP4s6D7XBnkZ3LU/LsgG4eRcrtqIOD/EFz7vfAp0rVq1v34YhV3mPDdUjzIMeunqpmitjD/2xeUpybtpLIZ8fpenFD5bRKGUbZrGYeTos/EyCjRjW7qIy05DnNtBx/mbfkeTbHcEENRGVppJXuf5nNwFT91URoRo9opC6sgEUD0hwElVH/8XCMIjPVjaa7JAm+UhnUS5r8ukBA60zYRb9x+qhJqxiAq9aQmyNN9499Y5eDAuwkGiTXR7yJHHPTBwfY9CfzfMa3cRJWOPdSeEgTqLyz20LWg50SUEhuhG0kidGiLuiZYybww== root@icp2103master" >> ~/.ssh/id_rsa.pub
          cat ~/.ssh/id_rsa.pub
          ssh -o StrictHostKeyChecking=no root@9.37.138.12 uptime
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
