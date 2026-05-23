#!/bin/bash
ip addr show tun0 | awk '/inet /{split($2,a,"/");print a[1];exit}'
