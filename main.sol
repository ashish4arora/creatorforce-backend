pragma solidity ^0.8.13;
contract main{
    enum Type{live, recorded};
    uint public liveCourseId;
    uint public recordedCourseId;

    constructor (){
        liveCourseId = 2; //live course ids are even
        recordedCourseId = 1; //recorded course ids are odd
    }

    struct Live{
        uint start_time;
        uint end_time;
        String title;
        String description;
        String extconnection; //basically cid or live video link 
        uint price; //in wei
        //uint maxcapacity;
    }
    struct Recorded{
        String title;
        String description;
        uint numLectures;
        uint price; //in wei
        Lecture[] lectures;
    }

    struct Lecture{
        String title;
        String description;
        String cid; //content id of the associated ipfs file
        // uint parentid;
    }

    //map of courseid with data
    map(uint => Live) public livecourses; //even mapping
    map(uint => Recorded) public recordedcourses; //odd mapping
    // we search for a courseid in both livecourses and recordedcourses

    //map for user nfts
    map(address => courseid) public usernft;
    //map for creator nfts
    map(address => courseid) public creatornft;

    function createLive(uint startTime, uint endTime, String title, String desc, String cid, uint price){
        Live session = Live(startTime, endTime, title, desc, cid, price);
        map[liveCourseId] = session;
        liveCourseId += 2;
    }

    //assuming struct of lectures is created using web3 and passed as a parameter
    function createRecorded(String title, String desc, uint numLectures, uint price, Lecture[] lectures){
        Recorded session = Recorded(title, desc, numlectures, price, lectures);
        recordedcourses[recordedCourseId] = session;
        recordedCourseId += 2;
    }

    // function createLectures(String title, String description, uint cid) returns (Lecture thelecture){
    //     Lecture thelecture = Lecture(title, description, cid);
    //     return thelecture;
    // }

    function buycourse(courseid) public {
        //add modifier to check whether courseid is valid or not
        if (courseid % 2 == 0){
            if (msg.value >= livecourses[courseid].price){
                address nftaddress; //stores the nft address generated either in frontend or from here?
                usernft[nftaddress] = courseid;
            }
        }else{
            if (msg.value >= recordedcourses[courseid].price){
                address nftaddress; //stuff said above
                usernft[nftadress] = courseid;
            }
        }
    }

    function fetchCourseUser(address[] nftlist) returns (String[] coursesEnrolled){
        String[] coursesEnrolled = [];
        for(uint i = 0; i < nftlist.length; i++){  
            if (usernft[nftlist[i]] > 0){
                coursesEnrolled.push(courseid);
            }
        }
        return coursesEnrolled;
    }

    function fetchCourseCreator(address[] nftlist) returns (String[] coursesEnrolled){
        String[] coursesCreated = [];
        for(uint i = 0; i < nftlist.length; i++){  
            if (usernft[nftlist[i]] > 0){
                coursesCreated.push(courseid);
            }
        }
        return coursesCreated;
    }
}
