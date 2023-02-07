##############################################################################
#Install Openshift Gitops
##############################################################################
echo "----------------------------------------
Installing Openshift Gitops
----------------------------------------"
##############################################################################
##############################################################################
echo "----------------------------------------
Setting Variables
----------------------------------------"
NAMESPACE=openshift-gitops
OPERATOR_GROUP_ACM=openshift-gitops
##############################################################################
##############################################################################
echo "----------------------------------------
Creating Namespace / Using Namespace
----------------------------------------"
oc create namespace $NAMESPACE || oc project $NAMESPACE
##############################################################################
##############################################################################
echo "----------------------------------------
Creating Openshift GitOps Subscription
----------------------------------------"
rm ./argocd/openshift-gitops-sub.yaml
echo "apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: openshift-gitops-operator
  namespace: openshift-operators
spec:
  channel: stable 
  installPlanApproval: Automatic
  name: openshift-gitops-operator 
  source: redhat-operators 
  sourceNamespace: openshift-marketplace " > ./argocd/openshift-gitops-sub.yaml
oc apply -f ./argocd/openshift-gitops-sub.yaml