// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract NeuralPost {
    string public creator;
    uint256 public postCount = 0;

    constructor() {
        creator = "Blyncnov Neural Social Post";
    }

    mapping(uint256 => Post) public posts;

    struct Post {
        uint256 id;
        string title;
        string content;
        address payable author;
        uint256 tipCoin;
    }

    function createPost(string memory _title, string memory _content) public {
        // Require valid content
        require(bytes(_title).length > 0);
        require(bytes(_content).length > 0);
        // Increment the post id
        postCount++;
        // Create Post
        posts[postCount] = Post(
            postCount,
            _title,
            _content,
            payable(msg.sender),
            0
        );
        // Trigger event
    }

    function tipCoin(uint256 _id) public payable {
        // Make sure the id is valid
        require(_id > 0 && _id <= postCount);
        // Fetch the Post
        Post memory _post = posts[_id];
        // fetch the Author
        address payable _author = _post.author;
        // Pay the author by sending them Ether
        payable(_author).transfer(msg.value);
        // Incremet the tip amount
        _post.tipCoin = _post.tipCoin + msg.value;
        // Update the post
        posts[_id] = _post;
        // Trigger an event
    }
}
