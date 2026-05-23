#!/bin/bash
m=$((0xffffffff << (32-$1) & 0xffffffff)); printf "%d.%d.%d.%d\n" $(( (m>>24)&255 )) $(( (m>>16)&255 )) $(( (m>>8)&255 )) $(( m&255 ))
