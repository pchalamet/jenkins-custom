build:
	docker build -t pchalamet/jenkins:latest jenkins

run:
	docker run -d -p 8080:8080 -v $(CURDIR)\configuration:/var/jenkins_home pchalamet/jenkins:latest
