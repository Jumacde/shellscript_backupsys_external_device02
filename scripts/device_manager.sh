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
	local mount1=0
	local mount2=0
	# chck mount status both devices
	[[ -d "$(dirname "$target_dir1")" ]] && mount1=1
        [[ -d "$(dirname "$target_dir2")" ]] && mount2=1

	case "${mount1}${mount2}" in
		# if both devices are mounted.
		"11")	
			mkdir -p "$(dirname "$target_dir1")"
        		mkdir -p "$(dirname "$target_dir2")"
			log_message "SUCCESS" "${target_dir1} and ${target_dir2} are mounted."
                        echo "SUCCESS"
                        ;;
		# if only device1 is mounted
		"10")	
			mkdir -p "$(dirname "$target_dir1")"
			log_message "WARN" "only ${target_dir1} is mounted."
                        echo "WARN1"
                        ;;
		# if only device2 is mounted
		"01")
			mkdir -p "$(dirname "$target_dir2")"
			log_message "WARN" "only ${target_dir2} is mounted."
                        echo "WARN2"
                        ;;
		# if both devices are not mounted
		"00") 
			log_message "FAILD" "both devices are not mounted."
                        echo "FAILED"
                        ;;
	esac
}

start_backup() {
	mount_result=$(check_mount)
	case "$mount_result" in
		"SUCCESS")
                        rsync -av --delete "$src_dir" "$target_dir1" >> "$log_dir" 2>&1
                        rsync -av --delete "$src_dir" "$target_dir2" >> "$log_dir" 2>&1
                        log_message "SUCCESS" "backup process to both devices is successfully finished."
                        exit 0
                        ;;
		"WARN1")
			rsync -av --delete "$src_dir" "$target_dir1" >> "$log_dir" 2>&1
                        log_message "SUCCESS" "backup process to ${target_dir1} is successfully finished."
                        exit 0
                        ;;
		"WARN2")
			mkdir -p "$target_dir2"
                        rsync -av --delete "$src_dir" "$target_dir2" >> "$log_dir" 2>&1
                        log_message "SUCCESS" "backup process to ${target_dir2} is successfully finished."
                        exit 0
                        ;;
		"FAILED")
			exit 1
			;;
	esac
}
