#!/bin/sh

# SHELL/DASH IPv6 lib to manipulate IPv6 addresses
# Example script
#
# Copyright (R) EasyNet Consuling SRL, Romania
# https://github.com/EasyNetDev
#

#__SHOW_ERRORS__=1
#__SHOW_INFO__=1
#__SHOW_WARNINGS__=1

# If you don't want to show the execution time, set this to 0
#__SHOW_EXECUTION_TIME__=1

SCRIPT_PATH=$(readlink -f $0)
SCRIPT_PATH=$(dirname ${SCRIPT_PATH})

if [ -f "${SCRIPT_PATH}/libipv6-tools.sh" ]; then
    . ${SCRIPT_PATH}/libipv6-tools.sh
else
    printf "ERROR: Missing ipv6-tools.sh lib!\n"
    exit 1
fi

if [ -f "${SCRIPT_PATH}/exec_time.sh" ]; then
    . ${SCRIPT_PATH}/exec_time.sh
else
    printf "ERROR: Missing exec_time.sh lib!\n"
    exit 1
fi

echo "1. Check if string is a valid IPv6:"
for IPv6_TEST in "::" "a001::" "::a001" "a001:b002::" "a001:b002:c003::" "a001:b002:c003:d004::" "a001:b002:c003:d004:e005::" "a001:b002:c003:d004:e005:f006::" "a001:b002:c003:d004:e005:f006:a007::" "a001:b002:c003:d004:e005:f006:a007:b008" "1abc:02ab::" "1abc::02ab:003a" "1abc::02ab::003a"  "1zas:02ab:003a:0004:5abc::" "abzc::" "1:2:3:4:5:6:7:8:9" "abcd:::123a:abcd"; do
    __START_MEASURE__
    ipv6_check "${IPv6_TEST}"
    RET=$?
    __END_MEASURE__
    if [ $RET -eq 0 ]; then
	printf "    IPv6 ${IPv6_TEST} has an valid IPv6 format\n"
    else
	printf "    String ${IPv6_TEST} has an invalid IPv6 format. "
	ipv6_check_errno ${RET}
    fi
    __EXECUTION_TIME__
done
#exit 0

echo
echo "2. IPv6 decompress tool:"
echo "  a. Test IPv6 decompression for IPv6 with compression :: at the end of address"
for IPv6_TEST in "1abc:02ab::" "1abc:02ab:003a::" "1abc:02ab:003a:0004::" "1abc:02ab:003a:0004:5abc::" "1abc:02ab:003a:0004:5abc:6abc::" "1abc:02ab:003a:0004:5abc:6abc:7abc::" "1abc:02ab:003a:0004:5abc:6abc:7abc:8abc" "1abc:02ab:003a:0004:5abc:6abc:7abc:8abc:9abc"; do
    __START_MEASURE__
    ipv6_decompress "${IPv6_TEST}" "IPv6_TUN_6RD_EXPAND"
    RET=$?
    __END_MEASURE__
    if [ ${RET} -eq 0 ]; then
	printf "    Before ${IPv6_TEST} and after ${IPv6_TUN_6RD_EXPAND}\n"

    else
	printf "    String ${IPv6_TEST} has an invalid IPv6 format. "
	ipv6_check_errno ${RET}
    fi
    __EXECUTION_TIME__
done
# exit 0

# Test case with :: inside of IPv6
echo
echo "  b. Test case of IPv6 with compression :: inside of the address"
for IPv6_TEST in "1abc::2abc" "1abc::02ab:003a" "1abc:02ab::003a:4abc" "1abc:02ab::003a:4abc:5abc" "1abc:02ab:003a::4abc:5abc:6abc" "1abc:02ab:003a:0004::5abc:6abc:7abc"; do
    __START_MEASURE__
    ipv6_decompress "${IPv6_TEST}" "IPv6_TUN_6RD_EXPAND"
    RET=$?
    __END_MEASURE__
    if [ ${RET} -eq 0 ]; then
	printf "    Before ${IPv6_TEST} and after ${IPv6_TUN_6RD_EXPAND}\n"
    else
	printf "    String ${IPv6_TEST} has an invalid IPv6 format. "
	ipv6_check_errno ${RET}
    fi
    __EXECUTION_TIME__
done
# exit 0

# Test case with :: at the begining of IPv6
echo
echo "  c. Test case of IPv6 with compression :: at begining of the address"
for IPv6_TEST in "::" "::1" "::1abc:2abc" "::1abc:02ab:003a" "::1abc:02ab:003a:4abc" "::1abc:02ab:003a:4abc:5abc" "::1abc:02ab:003a:4abc:5abc:6abc" "::1abc:02ab:003a:0004:5abc:6abc:7abc"; do
    __START_MEASURE__
    ipv6_decompress "${IPv6_TEST}" "IPv6_TUN_6RD_EXPAND"
    RET=$?
    __END_MEASURE__
    if [ ${RET} -eq 0 ]; then
	printf "    Before ${IPv6_TEST} and after ${IPv6_TUN_6RD_EXPAND}\n"
    else
	printf "    String ${IPv6_TEST} has an invalid IPv6 format. "
	ipv6_check_errno ${RET}
    fi
    __EXECUTION_TIME__
done
# exit 0

echo
echo "3. IPv6 compress tool:"
for IPv6_TEST in "0000:0000:0000:0000:0000:0000:0000:0000" "1abc:2abc:0000:0000:0000:0000:0000:0000" "1abc:0000:0000:0000:0000:2abc:0000:0000" "1abc:0000:0000:0000:2abc:0000:0000:0000" "1abc:0000:0000:2abc:0000:0000:0000:0000"; do
    __START_MEASURE__
    ipv6_compress "${IPv6_TEST}" "IPv6_TUN_6RD_COMPRESS"
    RET=$?
    __END_MEASURE__
    if [ ${RET} -eq 0 ]; then
	printf "  Before ${IPv6_TEST} and after ${IPv6_TUN_6RD_COMPRESS}\n"
    else
	printf "    String ${IPv6_TEST} has an invalid IPv6 format. "
	ipv6_check_errno ${RET}
    fi
    __EXECUTION_TIME__
done
# exit 0

echo
echo "4. IPv6 zero leading compression tool:"
for IPv6_TEST in "0000:0000:0000:0000:0000:0000:0000:0000" "1abc::0ab2:0cd3:0abc:0000:0000:0000" "1abc:2abc:0000:0000:0000:0000:0000:0000" "1abc:0000:0000:0000:0000:2abc:0000:0000" "1abc:000::0000:2abc:0000:0000" "1abc:0000:0000:0000:2abc:0000:0000:0000" "1abc:0000:0000:2abc:0000:0000:0000:0000"; do
    __START_MEASURE__
    ipv6_leading_zero_compression "${IPv6_TEST}" "IPv6_TUN_6RD_ZERO_LEADING"
    RET=$?
    __END_MEASURE__
    if [ ${RET} -eq 0 ]; then
	printf "  Before ${IPv6_TEST} and after ${IPv6_TUN_6RD_ZERO_LEADING}\n"
    else
	printf "    String ${IPv6_TEST} has an invalid IPv6 format. "
	ipv6_check_errno ${RET}
    fi
    __EXECUTION_TIME__
done
# exit 0

echo
echo "5. IPv6 get first address of the subnet:"
IPv6_TEST="1abc:2def:ffff:ffff::ffff"
for PREFIX in `seq 28 48`; do
    __START_MEASURE__
    ipv6_network_address "${IPv6_TEST}/${PREFIX}" "IPv6_FIRST_ADDRESS"
    RET=$?
    __END_MEASURE__

    if [ ${RET} -eq 0 ]; then
	printf "  The first IPv6 address ${IPv6_TEST}/${PREFIX} is ${IPv6_FIRST_ADDRESS}\n"
    else
	printf "    String ${IPv6_TEST} has an invalid IPv6 format. "
	ipv6_check_errno ${RET}
    fi
    __EXECUTION_TIME__
done
# exit 0
