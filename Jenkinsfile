pipeline {
    agent {
        node {
            label 'master'
        }
    }

    stages {

        stage('terraform started') {
            steps {
                sh 'echo "Started...!" '
            }
        }
        stage('git clone') {
            steps {
                sh 'sudo rm -r *;sudo git clone https://github.com/prasahnthmanohar/MongoDB.git'
            }
        }
        stage('terraform init') {
            steps {
                sh 'sudo /home/I354986/terraform init ../environments/terraform.tfvars'
            }
        }
        stage('terraform plan') {
            steps {
                sh 'sudo /home/I354986/terraform plan ../environments/terraform.tfvars'
            }
        }
	stage('approve') {
	     steps {
		input 'Do you approve deployment?'
	    }
	}
	stage('apply_changes') {
	     steps {
		sh "echo 'yes' | udo /home/I354986/terraform apply ../environments/terraform.tfvars"
		("Deployment logs from jenkins server $jenkins_server_url/jenkins/job/$JOB_NAME/$BUILD_NUMBER/console", notification_channel, [])
	    }
	}
   }
}
