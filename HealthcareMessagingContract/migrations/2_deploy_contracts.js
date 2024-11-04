const HealthcareMessaging = artifacts.require("HealthcareMessaging");

module.exports = function (deployer) {
    deployer.deploy(HealthcareMessaging);
};
