# Elastic-Stack

Deploy ELK Stack on Kubernetes
This guide provides instructions to deploy the ELK (Elasticsearch, Logstash, Kibana) stack on a Kubernetes cluster using a shell script. The script automates the deployment process using Helm charts from the Elastic Helm repository.

Prerequisites
Before running the script, ensure you have the following:

Kubernetes Cluster: A running Kubernetes cluster with access configured via kubectl.
Helm: Installed on your local machine. Helm Installation Guide
kubectl: Installed and configured to interact with your Kubernetes cluster. kubectl Installation Guide
Deployment Steps
Follow these steps to deploy the ELK stack:
Clone the Repository
Clone this repository or copy the deployment script to your local machine:

```
git clone https://github.com/krishh2512/Elastic-Stack.git
```
Make the Script Executable
Grant execute permissions to the script:
```
chmod +x deploy-elk.sh
```
Run the Deployment Script
Execute the script to deploy Elasticsearch, Logstash, and Kibana:
```
./deploy-elk.sh
```
The script will:
Create a namespace called elk.
Deploy Elasticsearch using the Elastic Helm chart.
Set up Logstash with a basic configuration.
Deploy Kibana with default settings.
Access Kibana
To access Kibana, use port forwarding:
```
kubectl port-forward service/kibana-kibana 5601:5601 -n elk
```
Open your browser and navigate to http://localhost:5601 to view the Kibana interface.

Customizing the Deployment
Elasticsearch Configuration: Modify the Helm values directly in the script to adjust the cluster size, resources, and other settings.
Logstash Configuration: The Logstash configuration is stored in a Kubernetes ConfigMap. You can edit the logstash.conf section in the script to adjust input, filter, and output settings.
Kibana Settings: Kibana is deployed with default settings, but you can change the service type or other Helm values in the script.
Troubleshooting
Check Logs: If any component fails to start, use kubectl logs to view the logs for Elasticsearch, Logstash, or Kibana.
Resource Issues: Ensure your Kubernetes cluster has sufficient resources (CPU, memory) for running the ELK stack.


Cleanup
To remove the ELK stack, run:
```
helm uninstall elasticsearch logstash kibana -n elk
kubectl delete namespace elk
```