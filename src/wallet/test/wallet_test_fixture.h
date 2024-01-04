// Copyright (c) 2016 The Bitcoin Core developers
// Copyright (c) 2017-2019 The Raven Core developers
// Copyright (c) 2020-2021 The CL Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef CL_WALLET_TEST_FIXTURE_H
#define CL_WALLET_TEST_FIXTURE_H

#include "test/test_cl.h"

/** Testing setup and teardown for wallet.
 */
struct WalletTestingSetup : public TestingSetup
{
    explicit WalletTestingSetup(const std::string &chainName = CBaseChainParams::MAIN);

    ~WalletTestingSetup();
};

#endif

