#!/bin/bash
#
# Name:          Roman Garcia
# Date:          20.03.2017
# 
# Automates the removal of parental controls from the Guest account
#

dscl . -mcxdelete /Users/Guest

exit 0
