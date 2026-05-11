const cds = require("@sap/cds");
const { sendWelcomeEmail } = require("./email-service");

class CosmicService extends cds.ApplicationService {
  init() {
    const validateSpacefarerData = (req) => {
      const data = req.data;
      console.log("🔍 validateSpacefarerData");
      console.log(data);

      const wormholeSkillThreshold = 0;
      const stardustCollectionThreshold = 0;

      let errorList = [];

      if (typeof data.wormholeNavigationSkill !== "number") {
        errorList.push("Wormhole navigation skill must be a number");
      }

      if (typeof data.stardustCollection !== "number") {
        errorList.push("Stardust collection must be a number");
      }

      if (data.wormholeNavigationSkill < wormholeSkillThreshold) {
        errorList.push(
          `Wormhole navigation skill must be above ${wormholeSkillThreshold}`,
        );
      }
      if (data.stardustCollection < stardustCollectionThreshold) {
        errorList.push(
          `Stardust collection must be above ${stardustCollectionThreshold}`,
        );
      }
      if (errorList.length > 0) {
        req.reject(400, errorList.join("\n\n"));
      }
    };

    const enhanceSpacefarerData = (data) => {
      console.log("enhanceSpacefarerData");
      const wormholeSkillEnhancement = 5;
      const stardustCollectionEnhancement = 5;

      data.wormholeNavigationSkill += wormholeSkillEnhancement;
      data.stardustCollection += stardustCollectionEnhancement;
    };

    this.before("CREATE", "Spacefarers", (req) => {
      validateSpacefarerData(req);
      enhanceSpacefarerData(req.data);
    });

    this.before("UPDATE", "Spacefarers", (req) => {
      console.log("🔍 Validating spacefarer update...");
      validateSpacefarerData(req);
    });

    this.after("CREATE", "Spacefarers", (result) => {
      sendWelcomeEmail(result);
    });

    return super.init();
  }
}

module.exports = { CosmicService };
