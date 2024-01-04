// Copyright (c) 2011-2014 The Bitcoin Core developers
// Copyright (c) 2017-2019 The Raven Core developers
// Copyright (c) 2020-2021 The CL Core developers
// Distributed under the MIT software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef CL_QT_CLADDRESSVALIDATOR_H
#define CL_QT_CLADDRESSVALIDATOR_H

#include <QValidator>

/** Base58 entry widget validator, checks for valid characters and
 * removes some whitespace.
 */
class ClAddressEntryValidator : public QValidator
{
    Q_OBJECT

public:
    explicit ClAddressEntryValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

/** cl address widget validator, checks for a valid cl address.
 */
class ClAddressCheckValidator : public QValidator
{
    Q_OBJECT

public:
    explicit ClAddressCheckValidator(QObject *parent);

    State validate(QString &input, int &pos) const;
};

#endif // CL_QT_CLADDRESSVALIDATOR_H
