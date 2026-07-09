#!/bin/bash
source "$(dirname "$0")/log_manager.sh"
ENV_FILE="$(dirname "$0")/.env"

# check exist of the .env file.
if [ -f "$ENV_FILE" ]; then
        export $(grep -v '^#' "$ENV_FILE" | xargs)
else
        echo "ERROR: .env file not found."
        exit 1 # if .env file not found end this script.
fi

src_dir="${backup_dir}"
target_dir1="${device_dir1}"
target_dir2="${device_dir2}"
mount_result=""

check_mount() {
	# if both devices are not mounted.
	if [ ! -d "$(dirname "$target_dir1")" ] && [ ! -d "$(dirname "$target_dir2")" ]; then
		log_message  "FAILD" "both devices are not mounted."
		echo "FAILED"
	# if only a devices is mounted.
	else if [ -d "$(dirname "$target_dir1")" ] && [ ! -d "$(dirname "$target_dir2")" ]; then
                log_message  "WARN" "only ${target_dir1} is mounted."
                echo "WARN1"
	else if [ ! -d "$(dirname "$target_dir1")" ] && [ -d "$(dirname "$target_dir2")" ]; then
                log_message  "WARN" "only ${target_dir1} is mounted."
                echo "WARN2"
	# if both devices are mounted-
	else 
		log_message "SUCCESS" "${target_dir1} and ${target_dir2} are mounted."
		echo "SUCCESS"
	fi
	mkdir -p "$(dirname "$target_dir1")"
        mkdir -p "$(dirname "$target_dir2")"
}

start_backup() {
	mount_result=$(check_mount)
if [ "$mount_result" = "SUCCESS" ]; then
	rsync -av --delete "$src_dir" "$target_dir1" "$target_dir2">> "$log_dir" 2>&1
	log_message "SUCCESS" "backup process to ${target_dir1} and ${target_dir2}  is successfully finished."
	exit 0
else if [ "$mount_result" = "WARN1" ]; then
        mkdir -p "$(dirname "$target_dir1")"
        rsync -av --delete "$src_dir" "$target_dir1" >> "$log_dir" 2>&1
        log_message "SUCCESS" "backup process to ${target_dir1} is successfully finished."
        exit 0
else if [ "$mount_result" = "WARN2" ]; then
        mkdir -p "$(dirname "$target_dir2")"
        rsync -av --delete "$src_dir"  "$target_dir2">> "$log_dir" 2>&1
        log_message "SUCCESS" "backup process to ${target_dir2}  is successfully finished."
        exit 0
fi
}
