// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 导入 OpenZeppelin 的 ERC721 和 ERC721URIStorage
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SunNFT is ERC721, ERC721URIStorage, Ownable {
    uint256 private _nextTokenId;

    // 构造函数：设置 NFT 的名称和符号
    constructor() ERC721("SUN NFT", "SUN") Ownable(msg.sender) {}

    // 铸造 NFT 函数
    // recipient: 接收 NFT 的钱包地址
    // uri: 元数据链接（IPFS 链接）
    function mintNFT(address recipient, string memory uri) public returns (uint256) {
        uint256 tokenId = _nextTokenId++;
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, uri);
        return tokenId;
    }

    // 必须重写这两个函数，因为继承了 ERC721URIStorage
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
