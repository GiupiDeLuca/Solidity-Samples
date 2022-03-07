// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.5;
pragma abicoder v2;


contract ownersOnly {

    address[] public owners;

    modifier onlyOwners {
        bool owner = false;
        for (uint i=0; i < owners.length; i++) {
            if (owners[i] == msg.sender) {
                owner = true;
            }
        }
        require(owner == true, "access restricted to owners");
        _;
    }

}
