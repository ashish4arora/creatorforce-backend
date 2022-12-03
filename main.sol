pragma solidity ^0.8.9;
contract main{
    // enum Type{live, recorded};
    uint public liveCourseId;
    uint public recordedCourseId;
    // address minteraddress;
    // SafeMeet minter = SafeMeet(minteraddress);
    // SafeMeet minter = new SafeMeet();
    constructor (){
        liveCourseId = 2; //live course ids are even
        recordedCourseId = 1; //recorded course ids are odd
        // minteraddress = 0xdC04977a2078C8FFDf086D618d1f961B6C546222;
        // SafeMeet minter = SafeMeet(minteraddress);
    }

    struct Live{
        uint start_time;
        uint end_time;
        string title;
        string description;
        string cid; //basically cid or live video link 
        uint price; //in wei
        //uint maxcapacity;
    }
    struct Recorded{
        string title;
        string description;
        uint numLectures;
        uint price; //in wei
        Lecture[] memorylectures; //hard fixing the max cap right now
    }

    struct Lecture{
        string title;
        string description;
        string cid; //content id of the associated ipfs file
        // uint parentid;
    }

    //map of courseid with data
    mapping(uint => Live) public livecourses; //even mapping
    mapping(uint => Recorded) public recordedcourses; //odd mapping
    // we search for a courseid in both livecourses and recordedcourses

    //map for user nfts
    mapping(uint256 => uint) public usernft;
    //map for creator nfts
    mapping(uint256 => uint) public creatornft;

    function createLive(uint startTime, uint endTime, string memory title, string memory desc, string memory cid, uint price, uint256 nftaddress) public{
        // Live memory session = Live(startTime, endTime, title, desc, cid, price);
        Live storage ref = livecourses[liveCourseId];
        ref.start_time = startTime;
        ref.end_time = endTime;
        ref.title = title;
        ref.description = desc;
        ref.cid = cid;
        ref.price = price;
        // livecourses[liveCourseId] = session;
        //nftaddress = minter.call{value:100, gas:10000}(abi.encodeWithSignature("safeMint(address)", msg.sender)); //get creator nft address
        creatornft[nftaddress] = recordedCourseId;
        liveCourseId += 2;
    }

    //assuming struct of lectures is created using web3 and passed as a parameter
    function createRecorded(string memory title, string memory desc, uint numLectures, uint price, Lecture[] memory lectures, uint256 nftaddress) public{
        // Recorded memory session = Recorded(title, desc, numLectures, price, lectures);
        // recordedcourses[recordedCourseId] = session;
        Recorded storage ref = recordedcourses[recordedCourseId];
        ref.title = title;
        ref.description = desc;
        ref.numLectures = numLectures;
        ref.price = price;
        for(uint i = 0; i < numLectures; i++){
            ref.memorylectures.push(lectures[i]);
        }
        // ref.memorylectures = lectures;
        creatornft[nftaddress] = recordedCourseId;
        recordedCourseId += 2;
    }

    // function createLectures(String title, String description, uint cid) returns (Lecture thelecture){
    //     Lecture thelecture = Lecture(title, description, cid);
    //     return thelecture;
    // }

    mapping(address=>mapping(uint256=>bool)) canMint;

    function buycourse(uint courseid) public payable returns (bool){
        //add modifier to check whether courseid is valid or not
        if (courseid % 2 == 0){
            if (msg.value >= livecourses[courseid].price){
                // address nftaddress; //stores the nft address generated either in frontend or from here?
                //usernft[nftaddress] = courseid;
                canMint[msg.sender][courseid] = true;
                // uint256 nftaddress = minter.safeMint(msg.sender);
                // usernft[nftaddress] = courseid;
                return true;
            }else{
                return false;
            }
        }else{
            if (msg.value >= recordedcourses[courseid].price){
                canMint[msg.sender][courseid] = true;
                // address nftaddress; //stuff said above
                // usernft[nftaddress] = courseid;
                // uint256 nftaddress;
                // nftaddress = minter.safeMint(msg.sender);
                // usernft[nftaddress] = courseid;
                return true;
            }else{
                return false;
            }
        }
    }

    function associateNft(uint courseid, uint256 tokenid) public {
        if (canMint[msg.sender][courseid]){
            usernft[tokenid] = courseid;
            
            canMint[msg.sender][courseid] = false;
        }
    }

    function fetchCourseUser(uint256[] memory nftlist) public returns (uint[] memory){
        // uint[] memory coursesEnrolled;
        //induces higher gas fees -> need to figure out a better way for this
        uint count = 0;
        for(uint i = 0; i < nftlist.length; i++){  
            if (usernft[nftlist[i]] > 0){
                // coursesEnrolled.push(usernft[nftlist[i]]);
                count ++;
            }
        }
        uint[] memory coursesEnrolled = new uint[](count);
        count = 0;
        for(uint i = 0; i < nftlist.length; i++){  
            if (usernft[nftlist[i]] > 0){
                coursesEnrolled[count] = usernft[nftlist[i]];
                count ++;
            }
        }
        return coursesEnrolled;
    }

    function fetchCourseCreator(uint256[] memory nftlist) public returns (uint[] memory){
        // uint[] memory coursesCreated;
        uint count = 0;
        for(uint i = 0; i < nftlist.length; i++){  
            if (creatornft[nftlist[i]] > 0){
                // coursesCreated.push(creatornft);
                count ++;
            }
        }
        uint[] memory coursesCreated = new uint[](count);
        count = 0;
         for(uint i = 0; i < nftlist.length; i++){  
            if (creatornft[nftlist[i]] > 0){
                coursesCreated[count] = creatornft[nftlist[i]];
                count ++;
            }
        }
        return coursesCreated;
    }
}
