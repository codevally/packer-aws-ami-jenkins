#!groovy
import jenkins.model.Jenkins

node {

    docker {
        image 'hashicorp/terraform:${params.TF_VERSION}'
        args '-v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app'
    }

  def err = null
  currentBuild.result = "SUCCESS"

  try {
    stage 'Checkout'
       checkout scm		


    stage 'Validate'
       print "Running packer validate on : ${params.PACKER_SCRIPT}"
       sh "packer -v ; packer validate ${params.PACKER_SCRIPT}"
  
    stage 'Build'
       print "Running packer build on : ${params.PACKER_SCRIPT}"

       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
		credentialsId: 'AWS_DEVOPS',  
		accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]) {

       sh """
          chmod +x env/packer_env.sh
          source env/packer_env.sh
          packer build ${params.PACKER_SCRIPT}
       """
	
       }

  }
  
  catch (caughtError) {
    err = caughtError
    currentBuild.result = "FAILURE"
  }

  finally {
    /* Must re-throw exception to propagate error */
    if (err) {
      throw err
    }
  }
}
