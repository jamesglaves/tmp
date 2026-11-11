#!/usr/bin/env bash
set -uo pipefail

SG_ID="sg-0123456789abcdef0"
CIDR_FILE="cidrs.txt"

while IFS= read -r cidr; do
    [[ -z "$cidr" || "$cidr" =~ ^# ]] && continue

    echo "Adding TCP/443 -> $cidr"

    if aws ec2 authorize-security-group-egress \
        --group-id "$SG_ID" \
        --protocol tcp \
        --port 443 \
        --cidr "$cidr"; then
        echo "  Added"
    else
        echo "  Failed or already exists"
    fi

done < "$CIDR_FILE"
