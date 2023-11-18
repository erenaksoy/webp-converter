# WebP Converter Bash Script

## Overview

This script automates the conversion of image files (JPEG and PNG) to WebP format. It provides features such as creating debug files, logging execution details, and maintaining a clean log directory. You can use it for any CMS or E-commerce like WordPress, Drupal, Joomla, Magento, Prestashop, Opencart etc. It's recursively generating the missing WebP files of the specific folder.

## Features

- **WebP Conversion:** Converts JPEG and PNG files to WebP format.
- **Logging:** Generates detailed debug files with execution information.
- **Dynamic Settings:** Reads configuration from a `config.txt` file.
- **Cleanup:** Automatically deletes old debug files based on a specified interval.

## Usage
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/erenaksoy/webp-converter.git
   cd webp-converter
   ```
2. **Configuration:**
   - Edit `config.txt` to adjust settings like `log_dir`, `debug_interval_hours`, and other parameters. Don't forget to replace `directory` to the your actual path.

3. **Execution:**
   - Run the script: `bash webp.sh`

4. **Logs:**
   - Debug files are stored in the specified log directory.

## Running with Cron Job

To automate the script execution, you can set up a cron job. For example, to run the script every day at 2:00 AM, add the following entry to your crontab:

1. Open the crontab file for editing:

```bash
crontab -e
```

2. Add a line to schedule the script. For example, to run daily at 2 AM:

```bash
0 2 * * * /path/to/webp.sh
```
Replace /path/to/your/webp.sh with the actual path to the script.

3. Save and exit the text editor.

## Debug Files
Debug files are generated in the specified log directory. Each file includes information about the script's execution, converted files, and errors.

### Note on Duplicate Skipping
The script checks for already converted WebP files and skips them to avoid duplication. If you need to re-generate all WebP files, set the generateall variable to 1 in the script.

```bash
generateall=1 # Re-generate all webp files
```
