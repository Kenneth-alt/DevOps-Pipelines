set -ex

VERSION=$TAG
cd ${WORKSPACE}/project_1

export AWS_PROFILE="aws_cred"

echo $AWS_PROFILE

whoami
aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin "731234385084.dkr.ecr.us-east-1.amazonaws.com"

sudo docker build -t arctick1 .

sudo docker tag arctick1:latest 731234385084.dkr.ecr.us-east-1.amazonaws.com/arctick1:$VERSION

sudo docker push 731234385084.dkr.ecr.us-east-1.amazonaws.com/arctick1:$VERSION

DOCKER_IMAGE="731234385084.dkr.ecr.us-east-1.amazonaws.com/arctick1:$VERSION"

sed -i "s@devops_image@$DOCKER_IMAGE@g" nginx_deployment.yaml

cat nginx_deployment.yaml

aws eks update-kubeconfig --name mycluster --region us-east-1 --profile aws_cred

kubectl apply -f nginx_deployment.yaml

kubectl expose deployment nginx-deployment --type=LoadBalancer --name=nginx-service
