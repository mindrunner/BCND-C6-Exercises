pragma solidity ^0.5.8;

contract ExerciseC6A {

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/


    uint constant M = 4;
    struct UserProfile {
        bool isRegistered;
        bool isAdmin;
    }

    bool private operational = true;
    address private contractOwner;                  // Account used to deploy contract
    mapping(address => UserProfile) userProfiles;   // Mapping for storing user profiles
    mapping(address => bool) multiCalls;   // Mapping for storing multi-call addresses
    address[] multiCallKeys = new address[](0);

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    // No events

    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor
                                (
                                ) 
                                public 
    {
        contractOwner = msg.sender;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireIsOperational()
    {
        require(operational, "Contract is not operational");
        _;
    }

    modifier requireIsAdmin()
    {
        require(userProfiles[msg.sender].isAdmin, "Caller is not an Admin");
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

   /**
    * @dev Check if a user is registered
    *
    * @return A bool that indicates if the user is registered
    */   
    function isUserRegistered
                            (
                                address account
                            )
                            external
                            view
                            returns(bool)
    {
        require(account != address(0), "'account' must be a valid address.");
        return userProfiles[account].isRegistered;
    }

    function isOperational() external view returns(bool) {
        return operational;
    }

    function setOperatingStatus(bool status) external requireIsAdmin {
        require(status != operational, "New status must be different from current status");
        bool isDuplicate = multiCalls[msg.sender];
        require(!isDuplicate, "Caller has already called this function");
        multiCalls[msg.sender] = true;
        multiCallKeys.push(msg.sender);
        if(multiCallKeys.length >= M) {
            operational = status;
            for(uint i = 0; i < multiCallKeys.length; ++i) {
                multiCalls[multiCallKeys[i]] = false;
            }
            multiCallKeys = new address[](0);
        }
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function registerUser
                                (
                                    address account,
                                    bool isAdmin
                                )
                                external
                                requireIsOperational
                                requireContractOwner
    {
        require(!userProfiles[account].isRegistered, "User is already registered.");

        userProfiles[account] = UserProfile({
                                                isRegistered: true,
                                                isAdmin: isAdmin
                                            });
    }
}

