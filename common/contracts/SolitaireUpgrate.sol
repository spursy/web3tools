pragma solidity ^0.4.23;

contract SolitaireUpgrate {
    uint depositAmount = 100 finney;
    uint firstWinerAmount = 30 finney;
    uint secondWinnerAmount = 70 finney;

    uint randomNumArrayLength = 0;

    uint randomNonce = 0;
    uint[] randomNumArray = new uint[](20);
    address[] addArray = new address[](20);

    // 当有新的随机数字添加到池中时触发该事件
    event AddNewRandomNum(address user, uint RandomNum);
    event WinCoin(address user, uint256 CoinCount);
    // 充值事件
    event Deposit(address user, uint256 amout);

    constructor() public payable{
    }

    function GetNonce() public returns (uint) {
        return randomNonce ++;
    }

    // 散列生成随机数字
    function GenerateRandom() public payable  returns (uint) {
        uint currentNonce = GetNonce();//GetNonce();

        uint random = uint(keccak256(abi.encodePacked(now, currentNonce)))%20;

        return random;
    }

    function SolitaireMain() public payable returns(uint) {
        uint randomNum = GenerateRandom();
        
        if (randomNumArrayLength == 0) {
            randomNumArray[randomNumArrayLength] = randomNum;
            randomNumArrayLength ++;
        } else {
            calculateWiners(randomNum);
        }   
    }

    // 计算随机数是否在存在池中
    function calculateWiners(uint randomNum) public  returns(uint[]) {
        bool isMatching = false;
        uint length = randomNumArrayLength;
        uint matchingindex;
        for (uint index = 0; index < length; index ++) {
            if (randomNum == randomNumArray[index]) {
                isMatching = true;
                matchingindex = index;
                break;
            }
        }
        if (!isMatching) {
            randomNumArray[randomNumArrayLength] = randomNum;
            addArray[randomNumArrayLength] = msg.sender;
            randomNumArrayLength ++;
            emit AddNewRandomNum(msg.sender, randomNum);
        } else {
            uint interval = randomNumArrayLength - matchingindex + 1;
            randomNumArrayLength = matchingindex;
            require(address(this).balance >= depositAmount * interval, "Contract address does not exist enough money.");
            addArray[matchingindex].transfer(firstWinerAmount * interval);
            msg.sender.transfer(secondWinnerAmount * interval);
            emit WinCoin(addArray[matchingindex], firstWinerAmount * interval);
            emit WinCoin(msg.sender, secondWinnerAmount * interval);
        }
        return randomNumArray;
    }

    function getRandomArrayLength() public view returns(uint) {
        return randomNumArrayLength;
    }

    function getRandomNumArray() public view returns(uint, uint[]) {
        return (randomNumArrayLength,randomNumArray);
    }

    // 通过合约地址充值触发该事件
    function () public payable{
        revert("Call deposit fun then generate new key");
        // require(msg.value == depositAmount, "Deposit money must be 100 finnery");
        // SolitaireMain();
        // emit Deposit(msg.sender, msg.value);
    }
   
    // 合约的充值函数
    function deposit() public payable {
        require(msg.value == depositAmount, "Deposit money must be 100 finnery");
        SolitaireMain();
        emit Deposit(msg.sender, msg.value);
    }

    // 获取合约余额的函数
    function GetBalance() public view returns(uint256) {
        return address(this).balance;
    }
}