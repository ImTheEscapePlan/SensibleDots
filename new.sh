#!/usr/bin/env bash

# ==============================================================================
# STEP-BASED EXTENSIBLE FRAMEWORK
# ==============================================================================

# --- STEP DEFINITIONS ---
# Define your custom steps as standard Bash functions here.

step_one() {
    echo "-> Running Step 1: Updating system logs..."
    # Add your actual logic here
    sleep 1 
    echo "-> Step 1 completed successfully."
}

step_two() {
    echo "-> Running Step 2: Clearing temporary caches..."
    # Add your actual logic here
    sleep 1
    echo "-> Step 2 completed successfully."
}

step_three() {
    echo "-> Running Step 3: Generating system report..."
    # Add your actual logic here
    sleep 1
    echo "-> Step 3 completed successfully."
}


# --- CORE ENGINE ---
# This function manages the prompts, validation loop, skips, and exits.

run_step() {
    local step_name="$1"
    local step_function="$2"

    while true; do
        # Prompt the user for input
        read -r -p "Do you want to run '$step_name'? (y/n/q): " user_choice

        case "$user_choice" in
            [Yy])
                echo -e "\n[EXECUTING] $step_name"
                echo "--------------------------------------------------"
                # Execute the passed function name
                $step_function
                echo "--------------------------------------------------"
                echo -e "Done.\n"
                break
                ;;
            [Nn])
                echo -e "[SKIPPED] $step_name.\n"
                break
                ;;
            [Qq])
                echo -e "\n[QUIT] Exiting script entirely. Goodbye!"
                exit 0
                ;;
            *)
                # Error handling / Type checking wrapper
                echo -e "Invalid input: '$user_choice'. Please type 'y' to continue, 'n' to skip, or 'q' to quit.\n"
                ;;
        esac
    done
}


# --- MAIN EXECUTIONFLOW ---
# This is where you orchestrate and sequence your script pipeline.

main() {
    echo "=================================================="
    echo " Starting Script Automation Pipeline"
    echo "=================================================="
    echo -e "Controls: [Y]es/Continue  |  [N]o/Skip  |  [Q]uit Script\n"

    # Register your steps here: run_step "Friendly Name" function_name
    run_step "System Log Update" step_one
    run_step "Cache Cleanup" step_two
    run_step "Report Generation" step_three

    echo "=================================================="
    echo " All pipeline steps processed successfully!"
    echo "=================================================="
}

# Fire off the main pipeline
main
