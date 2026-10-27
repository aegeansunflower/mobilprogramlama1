// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title AttendanceLedger
/// @notice Şarkışla UBYO yoklama zincirinin blok hash'lerini Ethereum uyumlu
///         bir ağa (ör. Polygon Amoy testnet) çapalar (anchor).
/// @dev Yoklama kayıtlarının kendisi zincir dışında (SQLite + Firestore)
///      kalır; KVKK gereği kişisel veri ağa yazılmaz. Ağa yalnızca blok
///      hash'i ve Merkle kökü gider. Bu iki değer, uygulamadaki zincirin
///      sonradan değiştirilmediğini herkese açık biçimde kanıtlar.
contract AttendanceLedger {
    struct Anchor {
        bytes32 blockHash;
        bytes32 merkleRoot;
        address authority;
        uint64 anchoredAt;
    }

    address public immutable admin;
    mapping(address => bool) public isAuthority;
    mapping(uint256 => Anchor) private anchors;
    uint256 public length;

    event AuthorityChanged(address indexed authority, bool allowed);
    event BlockAnchored(uint256 indexed index, bytes32 blockHash, bytes32 merkleRoot);

    error NotAdmin();
    error NotAuthority();
    error OutOfOrder(uint256 expected, uint256 got);

    constructor() {
        admin = msg.sender;
    }

    function setAuthority(address account, bool allowed) external {
        if (msg.sender != admin) revert NotAdmin();
        isAuthority[account] = allowed;
        emit AuthorityChanged(account, allowed);
    }

    /// @notice Bloklar sırayla çapalanır (append-only).
    function anchor(uint256 index, bytes32 blockHash, bytes32 merkleRoot) external {
        if (!isAuthority[msg.sender]) revert NotAuthority();
        if (index != length + 1) revert OutOfOrder(length + 1, index);
        anchors[index] = Anchor(blockHash, merkleRoot, msg.sender, uint64(block.timestamp));
        length = index;
        emit BlockAnchored(index, blockHash, merkleRoot);
    }

    function anchorOf(uint256 index)
        external
        view
        returns (bytes32 blockHash, bytes32 merkleRoot, address authority, uint64 anchoredAt)
    {
        Anchor memory a = anchors[index];
        return (a.blockHash, a.merkleRoot, a.authority, a.anchoredAt);
    }
}
