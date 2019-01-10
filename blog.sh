#!/bin/bash

case $1 in
     deploy)
        echo "Deploy blog to the cluster ..."
        helm install --name blog -f app/wordpress.yaml stable/wordpress > /dev/null 2>&1

        sleep 60s

        echo "You can access the blog with the detail below:"
        export SERVICE_IP=$(kubectl get svc --namespace default blog-wordpress --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
        echo "WordPress URL: http://$SERVICE_IP/"
        echo "Done"

        ;;
     scale)
        echo "Scaling blog ..."
        kubectl scale --replicas=$2 deployment/blog-wordpress
        ;;
     delete)
        echo "Deleting blog ..."
        helm delete --purge blog
        ;; 
     *)
        echo "deploy | scale <number of replicas> | delete"
        ;;
esac