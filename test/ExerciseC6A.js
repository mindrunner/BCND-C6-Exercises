const Test = require('../config/testConfig.js');

contract('ExerciseC6A', async (accounts) => {

    let config;
    before('setup contract', async () => {
        config = await Test.Config(accounts);
    });

    it('contract owner can register new user', async () => {

        // ARRANGE
        let caller = accounts[0]; // This should be config.owner or accounts[0] for registering a new user
        let newUser = config.testAddresses[0];

        // ACT
        await config.exerciseC6A.registerUser(newUser, false, {from: caller});
        let result = await config.exerciseC6A.isUserRegistered.call(newUser);

        // ASSERT
        assert.equal(result, true, "Contract owner cannot register new user");

    });

    // it('lockout test', async () => {
    //
    //     // ARRANGE
    //     let caller = accounts[0]; // This should be config.owner or accounts[0] for registering a new user
    //     let newUser = config.testAddresses[2];
    //
    //     // ACT
    //     await config.exerciseC6A.setOperatingStatus(false, {from: caller});
    //     let status = await config.exerciseC6A.isOperational();
    //     assert.equal(status, false);
    //     await config.exerciseC6A.setOperatingStatus(true, {from: caller});
    //     status = await config.exerciseC6A.isOperational();
    //     assert.equal(status, true);
    //
    //     await config.exerciseC6A.registerUser(newUser, false, {from: caller});
    //     let result = await config.exerciseC6A.isUserRegistered.call(newUser);
    //
    //     // ASSERT
    //     assert.equal(result, true, "Contract owner seems to be locked out");
    //
    // });

    it('multisig test', async () => {
        let owner = accounts[0];
        let admin1 = accounts[1];
        let admin2 = accounts[2];
        let admin3 = accounts[3];
        let admin4 = accounts[4];
        let admin5 = accounts[5];
        await config.exerciseC6A.registerUser(admin1, true, {from: owner});
        await config.exerciseC6A.registerUser(admin2, true, {from: owner});
        await config.exerciseC6A.registerUser(admin3, true, {from: owner});
        await config.exerciseC6A.registerUser(admin4, true, {from: owner});
        await config.exerciseC6A.registerUser(admin5, true, {from: owner});


        let changeStatus = !await config.exerciseC6A.isOperational();

        await config.exerciseC6A.setOperatingStatus(changeStatus, {from: admin1});
        let currentStatus = await config.exerciseC6A.isOperational();
        assert.equal(currentStatus, !changeStatus, "Multi-Party call fail");

        await config.exerciseC6A.setOperatingStatus(changeStatus, {from: admin2});
        currentStatus = await config.exerciseC6A.isOperational();
        assert.equal(currentStatus, !changeStatus, "Multi-Party call fail");


        await config.exerciseC6A.setOperatingStatus(changeStatus, {from: admin3});
        currentStatus = await config.exerciseC6A.isOperational();
        assert.equal(currentStatus, !changeStatus, "Multi-Party call fail");

        await config.exerciseC6A.setOperatingStatus(changeStatus, {from: admin4});
        currentStatus = await config.exerciseC6A.isOperational();
        assert.equal(currentStatus, changeStatus, "Multi-Party call fail");
    });
});
