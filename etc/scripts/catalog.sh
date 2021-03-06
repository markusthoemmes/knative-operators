#!/bin/bash

DIR=$(cd $(dirname "$0")/../../olm-catalog && pwd)
INDENT="      "

NAME="knative-operators"
NAMESPACE="openshift-operator-lifecycle-manager"
NAMEDISPLAY="Knative Operators"

CRD=$(cat $(ls $DIR/*crd.yaml) | grep -v -- "---" | sed "s/^/$INDENT/" | sed "s/ \( apiV\)/-\1/")
CSV=$(cat $(ls $DIR/*version.yaml) | sed "s/^/$INDENT/" | sed "s/ \( apiV\)/-\1/")
PKG=$(cat $(ls $DIR/*package.yaml) | sed "s/^/$INDENT/" | sed "s/ \( pack\)/-\1/")

cat <<EOF | sed 's/^  *$//'
kind: ConfigMap
apiVersion: v1
metadata:
  name: $NAME
  namespace: $NAMESPACE

data:
  customResourceDefinitions: |-
$CRD
  clusterServiceVersions: |-
$CSV
  packages: |-
$PKG
---
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  name: $NAME
  namespace: $NAMESPACE
spec:
  configMap: $NAME
  displayName: $NAMEDISPLAY
  publisher: Red Hat
  sourceType: internal
EOF
