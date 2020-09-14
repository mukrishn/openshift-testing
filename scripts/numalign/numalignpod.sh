i=0
NUM=$1
rm -rf align/
mkdir align
redis_pod=$(oc get pods -n redis | grep redis | awk {'print$1'})
oc exec -n redis ${redis_pod} -- redis-cli flushall
while [ $i -lt $NUM ]; do
cat <<EOF > align/pod-${i}.yaml
apiVersion: v1
kind: Pod
metadata:
  name: testpod-${i}
  annotations:
    k8s.v1.cni.cncf.io/networks: sriov-intel
spec:
  containers:
  - name: master
    image: quay.io/smalleni/numa
    command: ["/bin/sh", "-c"]
    args: [ "while true; do numalign; python3 redis-client.py; sleep 100000000000000; done;" ]
    env:
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    resources:
      limits:
        cpu: 1
        memory: 200Mi
        openshift.io/intelnics: 1
      requests:
        cpu: 1
        memory: 200Mi
        openshift.io/intelnics: 1
EOF
i=$((i+1))
done
oc create -f align/
