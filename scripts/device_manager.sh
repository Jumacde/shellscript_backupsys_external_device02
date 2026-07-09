#!/bin/bash
source "$(dirname "$0")/log_manager.sh"
ENV_FILE="$(dirname "$0")/.env"

if [ -f "$ENV_FILE" ]; then
        export $(grep -v '^#' "$ENV_FILE" | xargs)
else
        echo "ERROR: .env file not found."
        exit 1 # if .env file not found end this script.
fi

src_dir="${backup_dir}"
target_dir="${device_dir}"
mount_result=""

check_mount() {
	if [ ! -d "$(dirname "$target_dir")" ]; then
		log_message  "FAILD" "the device is not mounted."
		echo "FAILED"
	else 
		log_message "SUCCESS" "${target_dir} is mounted."
		echo "SUCCESS"
	fi

}

start_backup() {
	mount_result=$(check_mount)
if [ "$mount_result" = "SUCCESS" ]; then
	mkdir -p "$(dirname "$target_dir")"
	rsync -av --delete "$src_dir" "$target_dir" >> "$log_dir" 2>&1
	log_message "SUCCESS" "backup process is successfully finished."
	exit 0
fi
}
