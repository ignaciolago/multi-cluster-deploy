##############################################################################
#Install ACM
##############################################################################
echo "----------------------------------------
Installing Advance Cluster Manager
----------------------------------------"
##############################################################################
##############################################################################
echo "----------------------------------------
Setting Variables
----------------------------------------"
NAMESPACE=open-cluster-management
OPERATOR_GROUP_ACM=open-cluster-management
##############################################################################
##############################################################################
echo "----------------------------------------
Creating Namespace / Using Namespace
----------------------------------------"
oc create namespace $NAMESPACE || oc project $NAMESPACE
##############################################################################
##############################################################################
echo "----------------------------------------
Creating ACM Operator Group
----------------------------------------"
rm ./acm/acm-operator-group.yaml
echo "apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: $OPERATOR_GROUP_ACM
spec:
  targetNamespaces:
  - $NAMESPACE" > ./acm/acm-operator-group.yaml 
oc apply -f ./acm/acm-operator-group.yaml
##############################################################################
##############################################################################
echo "----------------------------------------
Creating ACM Subscription
----------------------------------------"
rm ./acm/acm-subscription.yaml
echo "apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: acm-operator-subscription
spec:
  sourceNamespace: openshift-marketplace
  source: redhat-operators
  channel: release-2.5
  installPlanApproval: Automatic
  name: advanced-cluster-management0" > ./acm/acm-subscription.yaml
oc apply -f ./acm/acm-subscription.yaml
##############################################################################
##############################################################################
echo "----------------------------------------
Creating Multi Cluster Hub
----------------------------------------"
rm ./acm/acm-custom-resource.yaml 
echo "apiVersion: operator.open-cluster-management.io/v1
kind: MultiClusterHub
metadata:
  name: multiclusterhub
  namespace: $NAMESPACE
spec: {}" > ./acm/acm-custom-resource.yaml
echo "wait for the resources to be avaible"
sleep 300 ; oc apply -f ./acm/acm-custom-resource.yaml || sleep 300 ; oc apply -f ./acm/acm-custom-resource.yaml || echo "If this step fails with the following error, the resources are still being created and applied. Run the command again in a few minutes when the resources are created: \
error: unable to recognize './mce.yaml': no matches for kind 'MultiClusterEngine' in version 'operator.multicluster-engine.io/v1' \
oc apply -f ./custom-resource.yaml"
##############################################################################
##############################################################################
echo "Run the following command to get the custom resource. It can take up to 10 minutes for the MultiClusterEngine custom resource status to display as Available in the status.phase field after you run the following command: \ 
oc get mce -o=jsonpath='{.items[0].status.phase}'"
oc get mce -o=jsonpath='{.items[0].status.phase}'


