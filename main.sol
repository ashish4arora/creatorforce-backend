pragma solidity ^0.8.13;
contract main{
    enum Type{live, recorded};
    uint liveCourseId;
    uint liveCourseId;
    uint recordedCourseId;

    constructor (){
        liveCourseId = 0; //live course ids are even
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
        uint[] lectures;
    }

    struct Lecture{
        String title;
        String description;
        String cid; //content id of the associated ipfs file
        uint parentid;
    }

    //map of courseid with data
    map(uint => Live) livecourses;
    map(uint => Recorded) recordedcourses;
    // we search for a courseid in both livecourses and recordedcourses

    //map for user nfts
    map(address => courseid) public usernft;
    //map for creator nfts
    map(address => courseid) public creatornft;

    function createLive(startTime, endTime, title, desc, cid, price){
        session = Live(startTime, endTime, title, desc, cid, price);
        
    }


    function buycourse(courseid) public {
        //add modifier to check whether courseid is valid or not
        if (msg.value >=  )
    }
}

