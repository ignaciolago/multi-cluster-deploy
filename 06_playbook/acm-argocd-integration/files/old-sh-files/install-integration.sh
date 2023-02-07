##############################################################################
#Integrating ACM + ArgoCD Integration
##############################################################################
echo "----------------------------------------
Integrating ACM & ArgoCD
----------------------------------------"
##############################################################################
##############################################################################
echo "----------------------------------------
Setting Variables
----------------------------------------"
NAMESPACE=open-cluster-management
OPERATOR_GROUP=multicluster-engine
CLUSTERNAME=remote-1653
CLUSTERNUMBER=01
##############################################################################
##############################################################################
echo "----------------------------------------
Using Namespace
----------------------------------------"
oc project $NAMESPACE
##############################################################################
##############################################################################
echo "----------------------------------------
Creating Managed Clusterset
----------------------------------------"
rm ./argocd-acm-integration/managedclusterset.yaml
echo "apiVersion: cluster.open-cluster-management.io/v1beta1
kind: ManagedClusterSet
metadata:
  name: gitops
  spec: {}" > ./argocd-acm-integration/managedclusterset.yaml
oc apply -f ./argocd-acm-integration/managedclusterset.yaml
##############################################################################
##############################################################################
echo "----------------------------------------
Creating Managed Clusterset Binding
----------------------------------------"
rm ./argocd-acm-integration/managedclustersetbinding.yaml
echo "apiVersion: cluster.open-cluster-management.io/v1beta1
kind: ManagedClusterSetBinding
metadata:
  name: gitops
  namespace: openshift-gitops
spec:
  clusterSet: gitops
" > ./argocd-acm-integration/managedclustersetbinding.yaml
oc apply -f ./argocd-acm-integration/managedclustersetbinding.yaml
##############################################################################
##############################################################################
echo "----------------------------------------
Creating Placement
----------------------------------------"
rm ./argocd-acm-integration/acm-placement.yaml
echo "apiVersion: cluster.open-cluster-management.io/v1beta1
kind: Placement
metadata:
  name: gitops
  namespace: openshift-gitops
spec:
  predicates:
  - requiredClusterSelector:
      labelSelector:
        matchExpressions:
        - key: vendor
          operator: 'In'
          values:
          - OpenShift
" > ./argocd-acm-integration/acm-placement.yaml
oc apply -f ./argocd-acm-integration/acm-placement.yaml
##############################################################################
##############################################################################
echo "----------------------------------------
Creating Placement
----------------------------------------"
rm ./argocd-acm-integration/acm-gitopscluster.yaml
echo "apiVersion: apps.open-cluster-management.io/v1beta1
kind: GitOpsCluster
metadata:
  name: argo-acm-clusters
  namespace: openshift-gitops
spec:
  argoServer:
    cluster: local-cluster
    argoNamespace: openshift-gitops
  placementRef:
    kind: Placement
    apiVersion: cluster.open-cluster-management.io/v1beta1
    name: gitops
    namespace: openshift-gitops" > ./argocd-acm-integration/acm-gitopscluster.yaml
oc apply -f ./argocd-acm-integration/acm-gitopscluster.yaml
##############################################################################
# Finished integrating ACM & ArgoCD
##############################################################################
echo "----------------------------------------
Finished integrating ACM & ArgoCD
----------------------------------------"
rm ./argocd-acm-integration/managed-cluster.yaml
echo "apiVersion: cluster.open-cluster-management.io/v1
kind: ManagedCluster
metadata:
  name: $CLUSTERNAME
  labels:
    name: $CLUSTERNAME
    cloud: auto-detect
    vendor: auto-detect
    cluster.open-cluster-management.io/clusterset: gitops
    cluster: '$CLUSTERNUMBER'
  annotations: {}
spec:
  hubAcceptsClient: true" > ./argocd-acm-integration/managed-cluster.yaml
oc apply -f ./argocd-acm-integration/managed-cluster.yaml

echo "Copy and run the command on the ACM Cluster Hub on the remote cluster"