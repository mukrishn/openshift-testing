NAMESPACE=$1
POD_NAME=$2
NOT_ALIGNED_COUNT=0
ALIGNED_COUNT=0
FAILED_COUNT=0
TOTAL=0

for pod in $(oc get pods -n $1 | grep $2| awk {'print$1'})
    do
       TOTAL=$((TOTAL+1))
       if [[ $(oc get pod/${pod} | tail -1 | awk {'print$3'}) =~ "Running" ]]; then
           ALIGNMENT=$(oc logs $pod | grep -i status | awk -F= {'print$2'})
           if [[ $ALIGNMENT =~ "false" ]]; then
               NOT_ALIGNED_COUNT=$((NOT_ALIGNED_COUNT+1))
           elif [[ $ALIGNMENT =~ "true" ]]; then
               ALIGNED_COUNT=$((ALIGNED_COUNT+1))
           fi
       else
           FAILED_COUNT=$((FAILED_COUNT+1))
       fi
    done

echo "The number of pods not aligned is $NOT_ALIGNED_COUNT"
echo "The number of pods aligned is $ALIGNED_COUNT"
echo "The total failed pods is $FAILED_COUNT"
