##############################################################################
#Install multicluster-engine
##############################################################################
echo "----------------------------------------
Installing Multi Cluster Engine
----------------------------------------"
##############################################################################
##############################################################################
echo "----------------------------------------
Setting Variables
----------------------------------------"
NAMESPACE=multicluster-engine
OPERATOR_GROUP=multicluster-engine
##############################################################################
##############################################################################
echo "----------------------------------------
Creating Namespace / Using Namespace
----------------------------------------"
oc create namespace $NAMESPACE || oc project $NAMESPACE
##############################################################################
##############################################################################
echo "----------------------------------------
Creating MCE Operator Group
----------------------------------------"
rm ./mce/mce-operator-group.yaml
echo "apiVersion: operators.coreos.com/v1
kind: OperatorGroup
metadata:
  name: $OPERATOR_GROUP
spec:
  targetNamespaces:
  - $NAMESPACE" > ./mce/mce-operator-group.yaml
oc apply -f ./mce/mce-operator-group.yaml
##############################################################################
##############################################################################
echo "----------------------------------------
Creating MCE Subscription
----------------------------------------"
rm ./mce/mce-subscription.yaml
echo "apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: multicluster-engine
spec:
  sourceNamespace: openshift-marketplace
  source: redhat-operators
  channel: stable-2.1
  installPlanApproval: Automatic
  name: multicluster-engine" > ./mce/mce-subscription.yaml
oc apply -f ./mce/mce-subscription.yaml
##############################################################################
##############################################################################
echo "----------------------------------------
Creating MCE Engine
----------------------------------------"
rm ./mce/mce-custom-resource.yaml
echo "apiVersion: multicluster.openshift.io/v1
kind: MultiClusterEngine
metadata:
  name: multiclusterengine
spec: {}" > ./mce/mce-custom-resource.yaml
echo "wait for the resources to be avaible"
sleep 300 ; oc apply -f ./mce/mce-custom-resource.yaml || sleep 300 ; oc apply -f ./mce/mce-custom-resource.yaml || echo "If this step fails with the following error, the resources are still being created and applied. Run the command again in a few minutes when the resources are created: \
error: unable to recognize './mce.yaml': no matches for kind 'MultiClusterEngine' in version 'operator.multicluster-engine.io/v1' \
oc apply -f ./custom-resource.yaml"

##############################################################################
# Finishing multicluster-engine installation
##############################################################################
echo "----------------------------------------
Finishing multicluster-engine installation
----------------------------------------"