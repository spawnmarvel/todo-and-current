# This prevents the "debconf" errors seen in the previous log
export DEBIAN_FRONTEND=noninteractive

LOG_DATE=$(date +%Y-%m-%d)
LOG_FILE="/var/log/apt-maintenance-$LOG_DATE.log"

echo "--- Maintenance Started: $(date) ---" > $LOG_FILE
sudo apt-get update -y >> $LOG_FILE 2>&1
# -o Dpkg::Options::="--force-confold" keeps existing configs and prevents prompts
sudo apt-get upgrade -y -o Dpkg::Options::="--force-confold" >> $LOG_FILE 2>&1
echo "--- Maintenance Finished: $(date) ---" >> $LOG_FILE

cat $LOG_FILE