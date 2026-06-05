#!/bin/bash
grep -Ev '^[[:space:]]*#|^[[:space:]]*$' /etc/ssh/sshd_config
