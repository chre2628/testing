# The following variables are defined in the environment 
# settings within config.yml
#	- CIRCLE_BRANCH
#	- AFFECTED_FILES
#	- CIRCLE_COMPARE_URL

touch ${AFFECTED_FILES}
commit_range=$(echo ${CIRCLE_COMPARE_URL} | awk -F"/" '{print $NF}')
if [[ "${CIRCLE_BRANCH}" != master ]]; then
  if [[ `echo ${commit_range} | grep "\.\."` != "" ]]; then
    startRange=$(echo ${commit_range} | awk -F"\." '{print $1}')
    endRange=$(echo ${commit_range} | awk -F"\." '{print $NF}')

    echo "Start Range: ${startRange}" \
	  &&  git show ${startRange}... --name-status 2>/dev/null | egrep "^[M|A|D]\s+" >> ${AFFECTED_FILES} || true

    echo "End Range: ${endRange}" \
	  &&  git show ${endRange} --name-status | egrep "^[M|A|D]\s+" >> ${AFFECTED_FILES} 2>/dev/null || true
  else 
    echo "Commit ID: ${commit_range}" \
	  &&  git show ${commit_range} --name-status | grep "^[M|A|D]\s+" >> ${AFFECTED_FILES}
  fi
  cat ${AFFECTED_FILES} | sort | uniq
 fi