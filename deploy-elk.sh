#!/bin/bash

# Set namespace
NAMESPACE="elk"

# Create namespace if not exists
kubectl create namespace $NAMESPACE || echo "Namespace $NAMESPACE already exists"

# Add Elastic Helm repo
helm repo add elastic https://helm.elastic.co
helm repo update

# Deploy Elasticsearch
echo "Deploying Elasticsearch..."
helm install elasticsearch elastic/elasticsearch --namespace $NAMESPACE \
  --set replicas=1 \
  --set minimumMasterNodes=1

# Wait for Elasticsearch to be ready
kubectl rollout status statefulset/elasticsearch-master -n $NAMESPACE

# Deploy Logstash
echo "Deploying Logstash..."

# Create Logstash ConfigMap
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: logstash-configmap
  namespace: $NAMESPACE
data:
  logstash.conf: |
    input {
      tcp {
        port => 5000
        codec => json
      }
    }
    output {
      elasticsearch {
        hosts => ["http://elasticsearch-master:9200"]
      }
    }
EOF

# Deploy Logstash using Helm
helm install logstash elastic/logstash --namespace $NAMESPACE \
  --set-file logstashPipelineConfigMap.logstash.conf=logstash-configmap

# Wait for Logstash to be ready
kubectl rollout status deployment/logstash -n $NAMESPACE

# Deploy Kibana
echo "Deploying Kibana..."
helm install kibana elastic/kibana --namespace $NAMESPACE \
  --set service.type=ClusterIP

# Wait for Kibana to be ready
kubectl rollout status deployment/kibana-kibana -n $NAMESPACE

echo "ELK Stack has been deployed successfully!"
