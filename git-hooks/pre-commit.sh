#!/usr/bin/env bash

# @source: https://gist.github.com/ronanguilloux/11f6a788358577474ab4
# @link http://tech.zumba.com/2014/04/14/control-code-quality/

Ruler='============================================================'

# end of Define Colors

PROJECT="."
STAGED_FILES_CMD=`git diff --cached --name-only --diff-filter=ACMR HEAD | grep \\\\.php`
EXIT_CODE=0

# Determine if a file list is passed
if [ "$#" -eq 1 ]
then
	oIFS=$IFS
	IFS='
	'
	STAGED_FILES="$1"
	IFS=$oIFS
fi

STAGED_FILES=${STAGED_FILES:-$STAGED_FILES_CMD}

# Intro
printf "${Ruler}\n"
printf "\t  _____ _____   _____  \n"
printf "\t |_   _|  __ \ / ____| \n"
printf "\t   | | | |__) | (___   \n"
printf "\t   | | |  ___/ \___ \  \n"
printf "\t  _| |_| |     ____) | \n"
printf "\t |_____|_|    |_____/  \n"
# end of Intro

# Detect PHP Version
PHP_MAJOR_MINOR="$(php -v | head -n 1 | awk '{print $2}' | cut -d '.' -f 1,2)"
PHP_FULL_VERSION=`php -r 'echo phpversion();'`

printf "${Ruler}\n"
printf "PHP version: ${PHP_MAJOR_MINOR} (${PHP_FULL_VERSION})\n"
printf "${Ruler}\n"

# Check all files in Commit with PHP CodeSniffer
for FILE in $STAGED_FILES
do
	printf "Processing file: $PROJECT/$FILE\n"
	printf "Checking for Syntax Errors: PHP Lint...\n"
	php -l -d display_errors=0 $PROJECT/$FILE

	if [ $? != 0 ]
	then
		printf "Fix the Syntax error before commit.\n"
		exit 1
	fi

	printf "${Ruler}\n"

	printf "Checking With PHP CodeSniffer... \n"
	php $PROJECT/vendor/bin/phpcs --standard=phpcs.xml --report=emacs $PROJECT/$FILE -n

	if [ $? != 0 ]
		then
			EXIT_CODE=1
	fi
done

if [ ${EXIT_CODE} != 0 ]
	then
		printf "Fix the Error before commit. \n"
		exit 1
	else
		printf "CodeSniffer: SUCCESS \n"
fi

exit $?