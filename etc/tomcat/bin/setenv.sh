# Display settings at startup
CATALINA_OPTS="$CATALINA_OPTS -XX:+PrintCommandLineFlags"

# Discourage address map swapping by setting Xms and Xmx to the same value
# http://confluence.atlassian.com/display/DOC/Garbage+Collector+Performance+Issues
CATALINA_OPTS="$CATALINA_OPTS -Xms64m"
CATALINA_OPTS="$CATALINA_OPTS -Xmx512m"

# Prevent "Unrecognized Name" SSL warning
CATALINA_OPTS="$CATALINA_OPTS -Djsse.enableSNIExtension=false"

# We need to send a 'portal.home' system property to the JVM;  use the value of PORTAL_HOME, if
# present, or fall back to a value calculated from $CATALINA_BASE
[ -z "$PORTAL_HOME" ] && PORTAL_HOME="$CATALINA_BASE/portal"
echo "PORTAL_HOME=$PORTAL_HOME"
CATALINA_OPTS="$CATALINA_OPTS -Dportal.home=$PORTAL_HOME"

# Checking if anyother garbage collectors have been defined. If no other garbage
# collector is present, default to G1GC
# List of options taken from:
# http://www.oracle.com/webfolder/technetwork/tutorials/obe/java/gc01/index.html
echo $CATALINA_OPTS | grep -e '-XX:+UseSerialGC' -e '-XX:+UseParallelGC' -e '-XX:ParallelGCThreads' -e '-XX:+UseParallelOldGC' -e '-XX:+UseConcMarkSweepGC' -e '-XX:+UseParNewGC' -e '-XX:+CMSParallelRemarkEnabled' -e '-XX:CMSInitiatingOccupancyFraction' -e '-XX:+UseCMSInitiatingOccupancyOnly' -e '-XX:+UseG1GC'
if [ $? -eq 1 ]
then
    CATALINA_OPTS="$CATALINA_OPTS -XX:+UseG1GC"
fi